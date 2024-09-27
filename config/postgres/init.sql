CREATE DATABASE worklinedb;

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    username VARCHAR(64) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    verified BOOLEAN,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    token TEXT DEFAULT NULL
);
CREATE TABLE IF NOT EXISTS companies (
    id UUID PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    company_name VARCHAR(64) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS roles (
    id UUID PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    description TEXT DEFAULT NULL,
    UNIQUE (name, company_id)
);
CREATE TABLE IF NOT EXISTS projects (
    id UUID PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    summary TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS boards (
    id UUID PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    type VARCHAR(20),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS columns (
    id UUID PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    board_id UUID REFERENCES boards(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS tasks (
    id UUID PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    description TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    column_id UUID REFERENCES columns(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS tags (
    id UUID PRIMARY KEY,
    name VARCHAR(32) NOT NULL
);
CREATE TABLE IF NOT EXISTS users_companies (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, company_id)
);
CREATE TABLE task_tags (
    task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
    tag_id UUID REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, tag_id)
);
CREATE TABLE user_roles (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, company_id, role_id)
);