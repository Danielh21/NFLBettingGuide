import fs from "fs";
import path from "path";

export function GetTeamLogo(teamName: string) {
  const logoDir = path.join(process.cwd(), "public", "logos");
  const nameToSearch = teamName?.trim()?.split(" ")?.pop()?.toLowerCase() ?? "";
  const files = fs.readdirSync(logoDir);
  const teamLogo = files.find((file) => {
    return file.toLowerCase().includes(nameToSearch);
  });
  return teamLogo ? `/logos/${teamLogo}` : "";
}
