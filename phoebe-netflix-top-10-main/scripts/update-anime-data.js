const fs = require("node:fs");
const path = require("node:path");

const dataPath = path.join(__dirname, "..", "anime-top10.json");
const data = JSON.parse(fs.readFileSync(dataPath, "utf8"));

function getTaipeiMondayNine(date = new Date()) {
  const taipeiDate = new Date(date.toLocaleString("en-US", { timeZone: "Asia/Taipei" }));
  const day = taipeiDate.getDay();
  const diffToMonday = (day + 6) % 7;
  taipeiDate.setDate(taipeiDate.getDate() - diffToMonday);
  taipeiDate.setHours(9, 0, 0, 0);
  return taipeiDate;
}

function toTaipeiIso(date) {
  const pad = (value) => String(value).padStart(2, "0");
  return [
    `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`,
    `T${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}+08:00`
  ].join("");
}

data.lastUpdated = toTaipeiIso(getTaipeiMondayNine());
data.updateSchedule = "Every Monday at 09:00";
data.timezone = "Asia/Taipei";

fs.writeFileSync(dataPath, `${JSON.stringify(data, null, 2)}\n`, "utf8");
console.log(`Updated ${path.basename(dataPath)} at ${data.lastUpdated}`);
