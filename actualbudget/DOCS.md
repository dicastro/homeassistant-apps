# Documentation: ActualBudget

ActualBudget is a super-fast, privacy-focused budgeting tool. This application runs the Actual server (Sync Server) to store your encrypted budget files.

## Configuration

ActualBudget in this repository is designed to work with its default internal settings. Most of the setup (admin password, budget files, and encryption) is performed directly through the Web UI once the application is started.

## 🌐 Recommended Proxy Configuration

ActualBudget **requires an SSL (HTTPS) connection** to enable remote access and synchronization.

| Configuration      | Value                                                    |
|:-------------------|:---------------------------------------------------------|
| Domain Name        | `finances.<YOUR_DOMAIN>`                                 |
| Scheme             | `http`                                                   |
| Forward Hostname   | `1da1ede7-actualbudget` (Internal HA hostname)           |
| Forward Port       | `5006`                                                   |
| Websockets Support | Enabled                                                  |
| SSL                | Force SSL enabled with a valid Let's Encrypt certificate |

If you encounter timeouts during synchronization, plan to attach documents to your transactions or your backups grow in size, add this to your proxy configuration:

**Advanced Nginx Snippet**

```nginx
  client_max_body_size 20M;

  proxy_read_timeout 300s;
  proxy_connect_timeout 300s;
  proxy_send_timeout 300s;
```

## ⚠️ Important Note on Password

The first time you access ActualBudget, you will be asked to set a password for the server. This password is independent of your Home Assistant user and is required to encrypt/decrypt your budget files. **Do not lose it**.

## 💾 Data & Backups

The application persists data across the locations:

- `/data` (mapped to HA `data` partition): database contents which includes all your financial data, encrypted budgets and server metadata

These locations automatically managed by Home Assistant, meaning all your information **is automatically included** in your Home Assistant backups/snapshots.