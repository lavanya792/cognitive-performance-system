#  CPS — Cognitive Performance System

> **Measure your mind. Track your fatigue. Beat your best.**

A real-time cognitive assessment app built with R Shiny — featuring reaction time testing, Stroop interference tasks, fatigue detection, composite scoring, and exportable session reports.

---

## Features

| Module | What it does |
|---|---|
| ⚡ **Reaction Time Test** | Click when the circle turns green. Measures raw neural response speed in milliseconds. |
| 🎨 **Stroop Interference Task** | Identify the ink color, not the word. Timed 3 seconds per trial. Tests cognitive control. |
| 🧮 **Composite Score** | Combines reaction speed + consistency bonus + Stroop accuracy into one performance number. |
| 😴 **Fatigue Detector** | Automatically analyses early vs late trial performance to flag cognitive fatigue in real time. |
| 🏆 **Leaderboard** | Tracks your best scores across sessions. |
| 📊 **Dashboard + Export** | Full performance summary with trend chart and downloadable HTML report. |

---

## 🚦 Fatigue Detection Logic

The app analyses 4 signals automatically:

```
RT Drift        →  Compares avg of first half vs second half of reaction trials
                   > 15% slower = fatigue flag 🔴

Response CV     →  Coefficient of variation across all reaction times
                   > 25% = inconsistency flag 🔴

Stroop Accuracy →  Overall correct / total Stroop trials
                   < 60% = cognitive load flag 🔴

Accuracy Trend  →  Is Stroop accuracy getting worse over time?
                   Declining trend = early fatigue 🟡
```

**Three states:**

```
✓  Cognitively Stable    →  No significant signals detected
◑  Early Fatigue Signs   →  1 mild signal detected — monitor closely  
⚠  Fatigued              →  2+ signals — take a break
```

---


## 📄 Session Report

Click **Download Report** in the Dashboard tab to get a full HTML report including:

- Reaction time stats (avg, best, trials)
- Stroop accuracy breakdown
- Composite score
- Fatigue status with signal breakdown table

---

## 🛠️ Built With

- **[R Shiny](https://shiny.posit.co/)** — Reactive web framework
- **[ggplot2](https://ggplot2.tidyverse.org/)** — Trend charts
- **[later](https://later.r-lib.org/)** — Async timing for reaction test
- **[Orbitron + Space Mono](https://fonts.google.com/)** — Google Fonts for the UI
- **[Shinylive](https://posit-dev.github.io/r-shinylive/)** — Serverless deployment via WebAssembly

---

## 📜 License

MIT — free to use, modify, and share.

---

<p align="center">Made with ☕ and R</p>


## Live Demo
(<https://lavanya03.shinyapps.io/reaction_app/>)
