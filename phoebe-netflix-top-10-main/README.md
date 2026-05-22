# Anime Top 10 Watchlist Side Project

Static side project for introducing weekly top 10 anime picks. The UI is written for Traditional Chinese readers and includes thumbnails, summaries, tags, trend labels, and a weekly update countdown.

## Features

- Weekly update countdown for Monday 09:00, Asia/Taipei
- Ranking data managed in `anime-top10.json`
- Thumbnail, summary, genres, episode status, and trend for every anime
- GitHub Pages deployment workflow
- Scheduled GitHub Actions refresh every Monday 09:00 Taiwan time

## Local Preview

The page fetches a JSON file, so preview it with a local server:

```bash
python -m http.server 8000
```

Then open:

```text
http://localhost:8000
```

## Updating Data

This project currently uses demo data and is not an official Netflix ranking.

Manual update:

```bash
node scripts/update-anime-data.js
```

After deploying to GitHub Pages, `.github/workflows/deploy-pages.yml` runs at 01:00 UTC every Monday, which is 09:00 in Asia/Taipei. The workflow refreshes `lastUpdated` and deploys the latest static site. To use a real ranking source, replace the logic inside `scripts/update-anime-data.js` with a licensed API, CSV import, or your own data pipeline.
