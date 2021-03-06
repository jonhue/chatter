DROP DATABASE chatter;
CREATE DATABASE chatter;
USE chatter;
DROP TABLE chats;
CREATE TABLE chats ( id bigint unsigned not null, user_id bigint unsigned not null, group_id bigint unsigned not null, name varchar(255) not null, primary key (id) );
DROP TABLE groups;
CREATE TABLE groups ( id bigint unsigned not null, user_id bigint unsigned not null, name varchar(255) not null, description varchar(255), primary key (id) );
DROP TABLE messages;
CREATE TABLE messages ( id bigint unsigned not null, user_id bigint unsigned not null, chat_id bigint unsigned not null, content varchar(255) not null, primary key (id) );
DROP TABLE users;
CREATE TABLE users ( id bigint unsigned not null, username varchar(255) not null, first_name varchar(255) not null, last_name varchar(255) not null, password varchar(255) not null, primary key (id) );
DROP TABLE user_chats;
CREATE TABLE user_chats ( id bigint unsigned not null, user_id bigint unsigned not null, chat_id bigint unsigned not null, primary key (id) );
DROP TABLE user_groups;
CREATE TABLE user_groups ( id bigint unsigned not null, user_id bigint unsigned not null, group_id bigint unsigned not null, primary key (id) );
-- INSERT INTO users ( id, name ) VALUES ( null, 'Sample data' );
