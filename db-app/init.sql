CREATE TABLE IF NOT EXISTS Users (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO USERS (id, name) VALUES (1, 'John Bandera') ON CONFLICT (id) DO NOTHING;
INSERT INTO USERS (id, name) VALUES (2, 'Jane Shuhevich') ON CONFLICT (id) DO NOTHING;
INSERT INTO USERS (id, name) VALUES (3, 'Bob Konovalets') ON CONFLICT (id) DO NOTHING;