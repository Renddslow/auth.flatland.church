/*
  Warnings:

  - Added the required column `shortcode` to the `App` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_App" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "shortcode" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "callback_url" TEXT NOT NULL,
    "allow_self_service_signup" BOOLEAN NOT NULL DEFAULT true,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL
);
INSERT INTO "new_App" ("allow_self_service_signup", "callback_url", "created_at", "description", "id", "name", "updated_at") SELECT "allow_self_service_signup", "callback_url", "created_at", "description", "id", "name", "updated_at" FROM "App";
DROP TABLE "App";
ALTER TABLE "new_App" RENAME TO "App";
CREATE UNIQUE INDEX "App_shortcode_key" ON "App"("shortcode");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
