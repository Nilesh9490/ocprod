#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install AWS CLI
if ! command_exists aws; then
  echo "Installing AWS CLI..."
  sudo apt-get update
  sudo apt-get install -y unzip
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
fi

# Install psql client if not already installed
if ! command_exists psql; then
  echo "Installing psql client..."
  sudo apt-get update
  sudo apt-get install -y postgresql-client
fi

# Install PostgreSQL 14.7 if not already installed
if ! command_exists psql14; then
  echo "Installing PostgreSQL 14.7..."
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install -y postgresql-14
fi

