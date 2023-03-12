db = db.getSiblingDB(process.env["MONGODB_DATABASE"]);

// Пользователь БД
db.createUser({
  user: process.env["MONGODB_USERNAME"],
  pwd:  process.env["MONGODB_PASSWORD"],
  roles: [{ role: "readWrite", db: process.env["MONGODB_DATABASE"] }],
});