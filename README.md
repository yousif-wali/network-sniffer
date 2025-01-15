# Zig Network Scanner

This project is a simple **network port scanner** written in **Zig**. It allows you to scan open ports on a specified IP address using **command-line arguments**.

## 📦 Features
- ✅ Scan a specified range of ports on a target IP.
- ✅ Display open ports in real-time.
- ✅ Command-line support for **IP address** and **port range**.
- ✅ Safe error handling and proper resource management.
- ✅ Built with **Zig 0.13.0**.

---

## 🚀 How to Compile and Run
### **Step 1: Clone the repository**
```bash
git clone https://github.com/yousif-wali/network-sniffer
cd network_scanner
```

### **Step 2: Build the project**
```bash
zig build
```

### **Step 3: Run the scanner with CLI inputs**
```bash
sudo ./zig-out/bin/network-sniffer <target_ip> <port_range>
```

### **Example:**
```bash
sudo ./zig-out/bin/network-sniffer 192.168.0.1 100
```

---

## 📖 Usage Example
```plaintext
Scanning target: 192.168.0.1 on ports 1 to 100
Port 22 is OPEN
Port 80 is OPEN

Open Ports Found:
Port: 22
Port: 80
```

---

## 📋 Project Structure
```plaintext
.
├── src/
│   └── main.zig    # Main source file for the network scanner
├── build.zig       # Zig build configuration
└── README.md       # Project documentation (this file)
```

---

## 🛠️ Dependencies
- **Zig 0.13.0+**
- **libpcap** (for packet capturing)
- **sudo** (for running with elevated permissions)

---

## ✅ Next Steps
- [ ] Parallel Scanning (for faster results "include timeout for port connections")
- [ ] Protocol Filtering (TCP/UDP filtering)
- [ ] Save Results to File
- [ ] IPv6 Support

---

## 📄 License
This project is licensed under the **MIT License**. Feel free to contribute!

---

**Happy Scanning!** 🎯
