#!/bin/bash
echo Wait for servers to be up
sleep 3

HOSTPARAMS="--host roach-node --insecure"
/cockroach/cockroach.sh init $HOSTPARAMS
SQL="/cockroach/cockroach.sh sql $HOSTPARAMS"

$SQL -e "CREATE DATABASE worklinedb;"
$SQL -d worklinedb -e "CREATE TABLE IF NOT EXISTS roles (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(64) NOT NULL,
    description TEXT DEFAULT NULL
);"
$SQL -d worklinedb -e "CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(64) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    verified BOOLEAN,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    token TEXT DEFAULT NULL
);"
$SQL -d worklinedb -e "CREATE TABLE IF NOT EXISTS companies (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    company_name VARCHAR(64) NOT NULL UNIQUE
);"
$SQL -d worklinedb -e "CREATE TABLE IF NOT EXISTS projects (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(64) NOT NULL,
    summary TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    company_id INT REFERENCES companies(id) ON DELETE CASCADE
);"
$SQL -d worklinedb -e "CREATE TABLE IF NOT EXISTS boards (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(64) NOT NULL,
    type VARCHAR(20),
    project_id INT REFERENCES projects(id) ON DELETE CASCADE
);"
$SQL -d worklinedb -e "CREATE TABLE IF NOT EXISTS columns (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(32) NOT NULL,
    board_id INT REFERENCES boards(id) ON DELETE CASCADE
);"
$SQL -d worklinedb -e "CREATE TABLE IF NOT EXISTS tasks (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(64) NOT NULL,
    description TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    column_id INT REFERENCES columns(id) ON DELETE CASCADE
);"
$SQL -d worklinedb -e "CREATE TABLE IF NOT EXISTS tags (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(32) NOT NULL
);"
$SQL -d worklinedb -e "CREATE TABLE IF NOT EXISTS users_companies (
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    company_id INT REFERENCES companies(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, company_id)
);"
$SQL -d worklinedb -e "CREATE TABLE task_tags (
    task_id INT REFERENCES tasks(task_id) ON DELETE CASCADE,
    tag_id INT REFERENCES tags(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, tag_id)
);"