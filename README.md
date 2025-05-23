# 🌅 Sunset API

Sunset API is a backend service built with Ruby on Rails that provides sunrise, sunset, and golden hour times for a given location and date range.

It fetches this data from the sunrisesunset.io API (https://api.sunrisesunset.io) and stores it in a local database to avoid repeated external requests for the same data.

## 📌 Example Request

```
GET http://127.0.0.1:3000/suntimes?lat=38.907192&lng=-77.036873&date_start=2025-01-01&date_end=2025-03-01
```

### Query Parameters

- `lat`: Latitude of the location (required)
- `lng`: Longitude of the location (required)
- `date_start`: Start date in YYYY-MM-DD format (required)
- `date_end`: End date in YYYY-MM-DD format (required)

## ⚙️ Setup Instructions

To run this project locally:

### 1. Clone the Repository

```bash
git clone https://github.com/mavegaf/sunset_api.git
cd sunset_api
```

### 2. Install Ruby Gems

```bash
bundle install
```

### 3. Prepare the Database

```bash
rails db:create
rails db:migrate
```

### 4. Start the Rails Server

```bash
rails server
```

Access the API at:
http://127.0.0.1:3000

## 🧪 Running Tests

```bash
bin/rails test
```

## 📁 Code Overview

- API entry point: `app/controllers/sun_times_controller.rb`
- External API logic and persistence: `app/services/sun_times_retriever.rb`
- Uses Faraday for HTTP requests
