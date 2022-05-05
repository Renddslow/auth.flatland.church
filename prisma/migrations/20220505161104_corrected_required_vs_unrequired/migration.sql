/*
  Warnings:

  - Made the column `action` on table `Audit` required. This step will fail if there are existing NULL values in that column.
  - Made the column `app_id` on table `Audit` required. This step will fail if there are existing NULL values in that column.
  - Made the column `user_id` on table `Audit` required. This step will fail if there are existing NULL values in that column.
  - Made the column `associated_id` on table `UserConnection` required. This step will fail if there are existing NULL values in that column.
  - Made the column `connection_id` on table `UserConnection` required. This step will fail if there are existing NULL values in that column.
  - Made the column `user_id` on table `UserConnection` required. This step will fail if there are existing NULL values in that column.
  - Made the column `callback_url` on table `App` required. This step will fail if there are existing NULL values in that column.
  - Made the column `description` on table `App` required. This step will fail if there are existing NULL values in that column.
  - Made the column `name` on table `App` required. This step will fail if there are existing NULL values in that column.
  - Made the column `app_id` on table `AppInvite` required. This step will fail if there are existing NULL values in that column.
  - Made the column `invite_code` on table `AppInvite` required. This step will fail if there are existing NULL values in that column.
  - Made the column `app_id` on table `UserApp` required. This step will fail if there are existing NULL values in that column.
  - Made the column `app_role_id` on table `UserApp` required. This step will fail if there are existing NULL values in that column.
  - Made the column `user_id` on table `UserApp` required. This step will fail if there are existing NULL values in that column.
  - Made the column `password` on table `User` required. This step will fail if there are existing NULL values in that column.
  - Made the column `app_id` on table `AppRole` required. This step will fail if there are existing NULL values in that column.
  - Made the column `name` on table `AppRole` required. This step will fail if there are existing NULL values in that column.
  - Made the column `shortcode` on table `AppRole` required. This step will fail if there are existing NULL values in that column.
  - Made the column `name` on table `Connection` required. This step will fail if there are existing NULL values in that column.
  - Made the column `url` on table `Connection` required. This step will fail if there are existing NULL values in that column.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Audit" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "action" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" INTEGER NOT NULL,
    "app_id" INTEGER NOT NULL,
    "affected_user_id" INTEGER,
    CONSTRAINT "Audit_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Audit_affected_user_id_fkey" FOREIGN KEY ("affected_user_id") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Audit_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "App" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Audit" ("action", "affected_user_id", "app_id", "createdAt", "id", "user_id") SELECT "action", "affected_user_id", "app_id", "createdAt", "id", "user_id" FROM "Audit";
DROP TABLE "Audit";
ALTER TABLE "new_Audit" RENAME TO "Audit";
CREATE TABLE "new_UserConnection" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "associated_id" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "connection_id" INTEGER NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    CONSTRAINT "UserConnection_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "UserConnection_connection_id_fkey" FOREIGN KEY ("connection_id") REFERENCES "Connection" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_UserConnection" ("associated_id", "connection_id", "created_at", "id", "updated_at", "user_id") SELECT "associated_id", "connection_id", "created_at", "id", "updated_at", "user_id" FROM "UserConnection";
DROP TABLE "UserConnection";
ALTER TABLE "new_UserConnection" RENAME TO "UserConnection";
CREATE TABLE "new_App" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "callback_url" TEXT NOT NULL,
    "allow_self_service_signup" BOOLEAN NOT NULL DEFAULT true,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL
);
INSERT INTO "new_App" ("allow_self_service_signup", "callback_url", "created_at", "description", "id", "name", "updated_at") SELECT "allow_self_service_signup", "callback_url", "created_at", "description", "id", "name", "updated_at" FROM "App";
DROP TABLE "App";
ALTER TABLE "new_App" RENAME TO "App";
CREATE TABLE "new_AppInvite" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "email" TEXT,
    "invite_code" TEXT NOT NULL,
    "app_id" INTEGER NOT NULL,
    "user_id" INTEGER,
    CONSTRAINT "AppInvite_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "AppInvite_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "App" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_AppInvite" ("app_id", "email", "id", "invite_code", "user_id") SELECT "app_id", "email", "id", "invite_code", "user_id" FROM "AppInvite";
DROP TABLE "AppInvite";
ALTER TABLE "new_AppInvite" RENAME TO "AppInvite";
CREATE UNIQUE INDEX "AppInvite_app_id_user_id_key" ON "AppInvite"("app_id", "user_id");
CREATE UNIQUE INDEX "AppInvite_app_id_email_key" ON "AppInvite"("app_id", "email");
CREATE TABLE "new_UserApp" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER NOT NULL,
    "app_id" INTEGER NOT NULL,
    "app_role_id" INTEGER NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    CONSTRAINT "UserApp_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "UserApp_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "App" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "UserApp_app_role_id_fkey" FOREIGN KEY ("app_role_id") REFERENCES "AppRole" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_UserApp" ("app_id", "app_role_id", "created_at", "id", "updated_at", "user_id") SELECT "app_id", "app_role_id", "created_at", "id", "updated_at", "user_id" FROM "UserApp";
DROP TABLE "UserApp";
ALTER TABLE "new_UserApp" RENAME TO "UserApp";
CREATE TABLE "new_User" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "email_is_verified" BOOLEAN DEFAULT false,
    "email_verification_code" TEXT,
    "email_verified_at" DATETIME,
    "phone_number" TEXT,
    "phone_number_is_verified" BOOLEAN DEFAULT false,
    "phone_number_verification_code" TEXT,
    "phone_number_verified_at" DATETIME,
    "password" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL
);
INSERT INTO "new_User" ("created_at", "email", "email_is_verified", "email_verification_code", "email_verified_at", "first_name", "id", "last_name", "password", "phone_number", "phone_number_is_verified", "phone_number_verification_code", "phone_number_verified_at", "updated_at") SELECT "created_at", "email", "email_is_verified", "email_verification_code", "email_verified_at", "first_name", "id", "last_name", "password", "phone_number", "phone_number_is_verified", "phone_number_verification_code", "phone_number_verified_at", "updated_at" FROM "User";
DROP TABLE "User";
ALTER TABLE "new_User" RENAME TO "User";
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
CREATE UNIQUE INDEX "User_phone_number_key" ON "User"("phone_number");
CREATE TABLE "new_AppRole" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "shortcode" TEXT NOT NULL,
    "can_grant_access" BOOLEAN NOT NULL DEFAULT false,
    "can_grant_role" BOOLEAN NOT NULL DEFAULT false,
    "app_id" INTEGER NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    CONSTRAINT "AppRole_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "App" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_AppRole" ("app_id", "can_grant_access", "can_grant_role", "created_at", "id", "name", "shortcode", "updated_at") SELECT "app_id", "can_grant_access", "can_grant_role", "created_at", "id", "name", "shortcode", "updated_at" FROM "AppRole";
DROP TABLE "AppRole";
ALTER TABLE "new_AppRole" RENAME TO "AppRole";
CREATE TABLE "new_Connection" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL
);
INSERT INTO "new_Connection" ("created_at", "id", "name", "updated_at", "url") SELECT "created_at", "id", "name", "updated_at", "url" FROM "Connection";
DROP TABLE "Connection";
ALTER TABLE "new_Connection" RENAME TO "Connection";
CREATE UNIQUE INDEX "Connection_name_key" ON "Connection"("name");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
