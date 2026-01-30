# Backend – Task Management API

This folder contains the backend API for the Task Management System.

## Tech Stack

- Node.js
- TypeScript
- Express
- Prisma ORM
- SQLite
- JWT Authentication


## Features

- User Registration, Login, and Logout
- JWT-based authentication (Access & Refresh Tokens)
- Secure password hashing using bcrypt
- Task CRUD operations
- Task ownership validation
- Pagination, filtering, and search
- Proper error handling and validation


## Setup Instructions

### 1. Install dependencies
```bash
npm install


## 2. Environment Variables

`` Create a .env file in this folder

PORT=3000
ACCESS_SECRET=your_access_secret
REFRESH_SECRET=your_refresh_secret

## 3. Run database migrations

npx prisma migrate dev

## 4. Start Server

npm run dev

## API Endpoints

Authentication

POST /auth/register

POST /auth/login

POST /auth/refresh

POST /auth/logout

Tasks

GET /tasks

POST /tasks

GET /tasks/:id

PATCH /tasks/:id

DELETE /tasks/:id

PATCH /tasks/:id/toggle