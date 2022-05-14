/*
  Warnings:

  - A unique constraint covering the columns `[invite_code]` on the table `AppInvite` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "AppInvite_invite_code_idx";

-- CreateIndex
CREATE UNIQUE INDEX "AppInvite_invite_code_key" ON "AppInvite"("invite_code");
