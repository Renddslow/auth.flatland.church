/*
  Warnings:

  - Added the required column `email_verification_code` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `email_verified_at` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `phone_number_verification_code` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `phone_number_verified_at` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_User" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "email_is_verified" BOOLEAN NOT NULL DEFAULT false,
    "email_verification_code" TEXT NOT NULL,
    "email_verified_at" DATETIME NOT NULL,
    "phone_number" TEXT NOT NULL,
    "phone_number_is_verified" BOOLEAN NOT NULL DEFAULT false,
    "phone_number_verification_code" TEXT NOT NULL,
    "phone_number_verified_at" DATETIME NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL
);
INSERT INTO "new_User" ("created_at", "email", "first_name", "id", "last_name", "phone_number", "updated_at") SELECT "created_at", "email", "first_name", "id", "last_name", "phone_number", "updated_at" FROM "User";
DROP TABLE "User";
ALTER TABLE "new_User" RENAME TO "User";
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
CREATE UNIQUE INDEX "User_phone_number_key" ON "User"("phone_number");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
