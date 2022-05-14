/*
  Warnings:

  - Added the required column `updated_at` to the `AppInvite` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_AppInvite" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "email" TEXT,
    "invite_code" TEXT NOT NULL,
    "app_id" INTEGER NOT NULL,
    "user_id" INTEGER,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "accepted_at" DATETIME,
    CONSTRAINT "AppInvite_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "AppInvite_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "App" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_AppInvite" ("app_id", "email", "id", "invite_code", "user_id") SELECT "app_id", "email", "id", "invite_code", "user_id" FROM "AppInvite";
DROP TABLE "AppInvite";
ALTER TABLE "new_AppInvite" RENAME TO "AppInvite";
CREATE INDEX "AppInvite_invite_code_idx" ON "AppInvite"("invite_code");
CREATE UNIQUE INDEX "AppInvite_app_id_user_id_key" ON "AppInvite"("app_id", "user_id");
CREATE UNIQUE INDEX "AppInvite_app_id_email_key" ON "AppInvite"("app_id", "email");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
