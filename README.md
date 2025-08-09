## 關於 Furries Board 專案

Furries Board 是一套專為獸圈社群設計的全端應用專案，核心功能為「徵筆友系統」，讓使用者能根據自身興趣、喜好與個人設定找到合適的交流對象。系統內建推薦機制，能自動根據使用者提供的資料匹配可能感興趣的筆友，促進有深度的交流與連結。

## ⚙️ 開發環境建置方式

### A️. 使用 Docker（✅ 推薦方式）

1.**Clone 專案**

```bash
git clone https://github.com/furries-board/furries-board.git
cd furries-board-latest
```

2.**安裝 Docker & Docker Compose**

3.**啟動容器**

```bash
docker compose up -d --build
```

4.**初始化資料庫（僅第一次）**

- 查詢容器 ID：

```bash
docker ps
```

找到 `IMAGE` 為 `furries-board-latest-nginx` 的容器，複製其 `CONTAINER ID`

- 進入容器並執行資料庫初始化：

```bash
docker exec -it <CONTAINER_ID> bash
php artisan migrate --seed
```

5.**啟動前端開發環境**

```bash
npm run dev      # 開發模式（支援熱更新）
# 或
npm run build    # 打包正式版前端資源
```

6.**.env 資料庫設定範例**

```dotenv
DB_CONNECTION=mysql
DB_HOST=host.docker.internal
DB_PORT=3306
DB_DATABASE=furries_board
DB_USERNAME=root
DB_PASSWORD=root
```

---

### B️. 手動安裝（不使用 Docker）

1.**安裝必要工具**

請根據作業系統安裝以下工具：

- PHP >= 8.3
- Composer
- Node.js & npm
- MySQL

    2.**安裝後端與前端依賴**

```bash
composer install
npm install
```

3.**啟動 Laravel 開發伺服器**

```bash
php artisan serve
```

4.**啟動前端開發環境**

```bash
npm run dev      # 熱更新模式
# 或
npm run build    # 打包前端資源
```

5.**設定 .env 檔資料庫連線資訊**

請根據你的本機環境調整 `.env` 中的 DB 相關欄位或者：

```dotenv
DB_CONNECTION=sqlite
# DB_HOST=host.docker.internal
# DB_PORT=3306
# DB_DATABASE=furries_board
# DB_USERNAME=root
# DB_PASSWORD=root
```

6.**初始化資料庫 (第一次)**

```
php artisan migrate --seed
```

## 📌 注意事項

- **推薦使用 Docker**，可避免跨平台環境差異造成問題。
- 資料庫初始化後，會自動產生預設使用者帳號（請查看 Seeder 設定）。

```
預設電子郵件：test@example.com
預設密碼：password
```
