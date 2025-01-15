const std = @import("std");
const net = std.net;
const Thread = std.Thread;

/// Scans a port and returns an ArrayList containing open ports
fn scanPort(allocator: std.mem.Allocator, ip: []const u8, port: u16) !std.ArrayList(u16) {
    var ports = std.ArrayList(u16).init(allocator);

    // Format the IP and port into a single string
    const address = try net.Address.resolveIp(ip, port);
    var socket = try net.tcpConnectToAddress(address);
    defer socket.close();

    // If the connection is successful, consider the port open
    try ports.append(port);
    std.debug.print("Port {} is OPEN\n", .{port});
    return ports;
}

/// Worker function to scan ports concurrently
fn scanPortWorker(allocator: std.mem.Allocator, ip: []const u8, start_port: u16, end_port: u16, open_ports: *std.ArrayList(u16)) void {
    for (start_port..end_port + 1) |port_index| {
        if (port_index > 65535) continue; // ✅ Prevent invalid casting
        const port: u16 = @intCast(port_index);

        const result = scanPort(allocator, ip, port) catch continue;
        open_ports.appendSlice(result.items) catch {};
        result.deinit();
    }
}

/// Main function to scan ports based on CLI arguments
pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var open_ports = std.ArrayList(u16).init(allocator);
    defer open_ports.deinit(); // ✅ Free memory properly

    // ✅ Collect arguments from CLI
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 3) {
        std.debug.print("Usage: ./packet_sniffer <target_ip> <port_range>\n", .{});
        return;
    }

    const target_ip = args[1];
    const port_range = try std.fmt.parseInt(u16, args[2], 10);

    std.debug.print("Scanning target: {s} on ports 1 to {}\n", .{ target_ip, port_range });

    // ✅ Multi-threading setup for faster parallel scanning
    const thread_count = 20;
    const ports_per_thread = @divExact(port_range, thread_count);

    var threads: [thread_count]Thread = undefined;
    for (0..thread_count) |i| {
        const start_port = @as(u16, @intCast(i * ports_per_thread + 1));
        const end_port = if (i == thread_count - 1) port_range else @as(u16, @intCast((i + 1) * ports_per_thread));

        // ✅ Correct thread spawning with updated args
        threads[i] = try Thread.spawn(.{}, scanPortWorker, .{ allocator, target_ip, start_port, end_port, &open_ports });
    }

    // ✅ Wait for all threads to finish
    for (threads) |thread| {
        thread.join();
    }

    // ✅ Print results after scanning
    std.debug.print("\nOpen Ports Found:\n", .{});
    for (open_ports.items) |port| {
        std.debug.print("Port: {}\n", .{port});
    }
}
