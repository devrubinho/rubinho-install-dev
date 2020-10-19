# Anotações de Docker

## Postgres

`docker run --name database -e POSTGRES_PASSWORD=docker -p 5432:5432 -d postgres`

> Altere onde tem database para o nome da imagem que deseja e na opção postgres_password. Escolha uma senha segura para o banco.

## Mongo

`docker run --name NOME_DA_IMAGEM -p 27017:27010 -d -t mongo`

## Redis

`docker run --name NOME_DO_CONTAINER -p 6379:6379 -d -t redis:alpine`