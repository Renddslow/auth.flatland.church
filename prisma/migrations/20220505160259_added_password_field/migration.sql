-- AlterTable
ALTER TABLE "User" ADD COLUMN "password" TEXT;

-- CreateTable
CREATE TABLE "AppInvite" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "email" TEXT NOT NULL,
    "invite_code" TEXT,
    "app_id" INTEGER,
    "user_id" INTEGER NOT NULL,
    CONSTRAINT "AppInvite_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "AppInvite_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "App" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_App" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT,
    "description" TEXT,
    "callback_url" TEXT,
    "allow_self_service_signup" BOOLEAN NOT NULL DEFAULT true,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL
);
INSERT INTO "new_App" ("callback_url", "created_at", "description", "id", "name", "updated_at") SELECT "callback_url", "created_at", "description", "id", "name", "updated_at" FROM "App";
DROP TABLE "App";
ALTER TABLE "new_App" RENAME TO "App";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

-- CreateIndex
CREATE UNIQUE INDEX "AppInvite_app_id_user_id_key" ON "AppInvite"("app_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "AppInvite_app_id_email_key" ON "AppInvite"("app_id", "email");
