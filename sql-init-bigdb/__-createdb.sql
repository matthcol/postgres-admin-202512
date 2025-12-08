create database dbmedia encoding 'UTF-8';
create user media with login password 'password';

\c dbmedia

grant all on schema public to media;