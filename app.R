library(shiny)
library(ggplot2)
library(later)

google_fonts <- tags$link(
  href = "https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Space+Mono:wght@400;700&family=Inter:wght@300;400;500;600&display=swap",
  rel  = "stylesheet"
)

css <- "
:root {
  --bg:       #eef2f7;
  --surface:  #ffffff;
  --surface2: #f4f7fb;
  --border:   rgba(30,100,180,0.11);
  --accent:   #1e64b4;
  --teal:     #0b8f72;
  --purple:   #6d4bbf;
  --danger:   #d63251;
  --warn:     #c47a0a;
  --text:     #0f1d2e;
  --muted:    #637085;
}
* { box-sizing:border-box; margin:0; padding:0; }
html, body {
  min-height:100%;
  background:var(--bg);
  color:var(--text);
  font-family:'Inter',sans-serif;
  font-size:15px;
}
body::after {
  content:''; position:fixed; inset:0; pointer-events:none; z-index:0;
  background:
    radial-gradient(ellipse 65% 38% at 0% 0%, rgba(30,100,180,0.07) 0%, transparent 55%),
    radial-gradient(ellipse 55% 35% at 100% 100%, rgba(109,75,191,0.06) 0%, transparent 55%);
}
.top-nav {
  position:sticky; top:0; z-index:200;
  height:60px;
  background:rgba(255,255,255,0.92);
  backdrop-filter:blur(20px);
  -webkit-backdrop-filter:blur(20px);
  border-bottom:1px solid var(--border);
  box-shadow:0 1px 12px rgba(30,100,180,0.07);
  display:flex; align-items:center;
  padding:0 36px; gap:20px;
}
.nav-brand {
  font-family:'Orbitron',monospace;
  font-weight:900; font-size:15px; letter-spacing:0.1em;
  color:var(--accent); flex-shrink:0;
}
.nav-brand em { font-style:normal; color:var(--teal); }
.nav-div { width:1px; height:20px; background:var(--border); }
.top-nav .nav.nav-tabs {
  border:none !important;
  display:flex; gap:2px; margin:0 !important; flex-wrap:nowrap;
}
.top-nav .nav.nav-tabs > li > a {
  font-family:'Space Mono',monospace !important;
  font-size:10px !important; letter-spacing:0.07em !important;
  color:var(--muted) !important; background:transparent !important;
  border:1px solid transparent !important; border-radius:7px !important;
  padding:6px 13px !important; transition:all 0.18s !important;
  white-space:nowrap !important; text-transform:uppercase !important;
}
.top-nav .nav.nav-tabs > li.active > a,
.top-nav .nav.nav-tabs > li > a:hover {
  color:var(--accent) !important;
  background:rgba(30,100,180,0.07) !important;
  border-color:rgba(30,100,180,0.2) !important;
}
.tab-content { border:none !important; background:transparent !important; }
.shiny-tab-content, .tab-content > .active { padding:0 !important; }
.shell {
  max-width:1060px; margin:36px auto;
  padding:0 24px; position:relative; z-index:1;
}
.card {
  background:var(--surface);
  border:1px solid var(--border);
  border-radius:16px;
  padding:28px 30px; margin-bottom:20px;
  box-shadow:0 2px 18px rgba(30,100,180,0.07);
  position:relative; overflow:hidden;
}
.card::before {
  content:''; position:absolute;
  top:0; left:0; right:0; height:3px;
  border-radius:16px 16px 0 0;
  background:linear-gradient(90deg,var(--accent),var(--teal));
}
.card-teal::before  { background:linear-gradient(90deg,var(--teal),#3dcca6); }
.card-purple::before{ background:linear-gradient(90deg,var(--purple),#a07ee0); }
.card-fatigue::before { background:linear-gradient(90deg,#d63251,#c47a0a); }
.sec-label {
  font-family:'Orbitron',monospace;
  font-size:10px; font-weight:700; letter-spacing:0.16em; text-transform:uppercase;
  color:var(--accent); margin-bottom:6px;
  display:flex; align-items:center; gap:10px;
}
.sec-label::after { content:''; flex:1; height:1px; background:var(--border); }
.sec-desc { font-size:13px; color:var(--muted); margin-bottom:26px; line-height:1.55; }
.stat-grid {
  display:grid;
  grid-template-columns:repeat(auto-fit,minmax(150px,1fr));
  gap:14px; margin-bottom:24px;
}
.stat-tile {
  background:var(--surface2); border:1px solid var(--border);
  border-radius:12px; padding:18px 16px; text-align:center;
  transition:all 0.18s; box-shadow:0 1px 4px rgba(30,100,180,0.04);
}
.stat-tile:hover {
  border-color:rgba(30,100,180,0.25);
  box-shadow:0 4px 14px rgba(30,100,180,0.09);
  transform:translateY(-1px);
}
.stat-big {
  font-family:'Orbitron',monospace;
  font-size:26px; font-weight:900; color:var(--accent); line-height:1; margin-bottom:5px;
}
.stat-big.g { color:var(--teal); }
.stat-big.o { color:var(--warn); }
.stat-big.p { color:var(--purple); }
.stat-big.r { color:var(--danger); }
.stat-small { font-size:10px; letter-spacing:0.1em; text-transform:uppercase; color:var(--muted); }
.cps-btn {
  display:inline-flex; align-items:center; gap:8px;
  font-family:'Space Mono',monospace;
  font-size:11px; letter-spacing:0.07em; font-weight:700;
  text-transform:uppercase; border-radius:9px;
  padding:9px 20px; cursor:pointer;
  border:none; transition:all 0.18s;
}
.cps-btn-blue {
  background:var(--accent); color:#fff;
  box-shadow:0 2px 10px rgba(30,100,180,0.28);
}
.cps-btn-blue:hover {
  background:#1558a0; color:#fff;
  box-shadow:0 4px 18px rgba(30,100,180,0.38); transform:translateY(-1px);
}
.cps-btn-ghost {
  background:var(--surface2); color:var(--muted);
  border:1px solid var(--border);
}
.cps-btn-ghost:hover { background:#e5ecf5; color:var(--text); }
.btn { border-radius:9px !important; }
#click {
  font-family:'Orbitron',monospace !important;
  font-size:13px !important; font-weight:700 !important;
  letter-spacing:0.14em !important; text-transform:uppercase !important;
  width:210px !important; height:210px !important; border-radius:50% !important;
  border:2.5px solid rgba(214,50,81,0.45) !important;
  background:rgba(214,50,81,0.05) !important;
  color:var(--danger) !important;
  box-shadow:0 0 28px rgba(214,50,81,0.1) !important;
  transition:all 0.15s !important;
}
.go-btn {
  border-color:rgba(11,143,114,0.55) !important;
  background:rgba(11,143,114,0.06) !important;
  color:var(--teal) !important;
  box-shadow:0 0 36px rgba(11,143,114,0.18) !important;
}
.reaction-center {
  display:flex; flex-direction:column; align-items:center; gap:22px; padding:16px 0;
}
.reaction-row { display:flex; gap:12px; flex-wrap:wrap; justify-content:center; }
.stroop-stage {
  display:flex; flex-direction:column; align-items:center; gap:18px; padding:10px 0 6px;
}
.stroop-word {
  font-family:'Orbitron',monospace;
  font-size:54px; font-weight:900; letter-spacing:0.1em;
  animation:breathe 1.6s ease-in-out infinite alternate;
}
@keyframes breathe {
  from { opacity:.82; transform:scale(.975); }
  to   { opacity:1;   transform:scale(1.015); }
}
.timer-badge {
  font-family:'Orbitron',monospace; font-size:17px; font-weight:700;
  color:var(--warn); background:rgba(196,122,10,0.07);
  border:1.5px solid rgba(196,122,10,0.28);
  border-radius:50%; width:54px; height:54px;
  display:flex; align-items:center; justify-content:center;
}
.stroop-row { display:flex; gap:10px; flex-wrap:wrap; justify-content:center; margin-top:4px; }
.stroop-row .btn {
  font-family:'Space Mono',monospace !important;
  font-size:11px !important; font-weight:700 !important;
  letter-spacing:0.09em !important; text-transform:uppercase !important;
  padding:9px 26px !important; border-radius:9px !important; transition:all 0.16s !important;
}
#red   { background:rgba(214,50,81,0.07)   !important; border:1.5px solid rgba(214,50,81,0.3)   !important; color:#b82040 !important; }
#blue  { background:rgba(30,100,180,0.07)  !important; border:1.5px solid rgba(30,100,180,0.3)  !important; color:#1e64b4 !important; }
#green { background:rgba(11,143,114,0.07)  !important; border:1.5px solid rgba(11,143,114,0.3)  !important; color:#0b7a5e !important; }
#red:hover   { box-shadow:0 3px 12px rgba(214,50,81,0.18)  !important; transform:translateY(-2px) !important; }
#blue:hover  { box-shadow:0 3px 12px rgba(30,100,180,0.18) !important; transform:translateY(-2px) !important; }
#green:hover { box-shadow:0 3px 12px rgba(11,143,114,0.18) !important; transform:translateY(-2px) !important; }
.verdict {
  font-family:'Orbitron',monospace; font-size:13px;
  letter-spacing:0.13em; text-transform:uppercase; min-height:22px; text-align:center;
}
.paused-note {
  text-align:center; font-family:'Space Mono',monospace;
  font-size:11px; letter-spacing:0.1em; text-transform:uppercase;
  color:var(--muted); padding:12px; background:var(--surface2);
  border:1px solid var(--border); border-radius:10px; margin-bottom:14px;
}
.score-hero { display:flex; flex-direction:column; align-items:center; gap:18px; padding:30px 0 24px; }
.score-ring {
  width:170px; height:170px; border-radius:50%;
  border:2.5px solid rgba(30,100,180,0.2);
  background:radial-gradient(circle, rgba(30,100,180,0.04) 0%, transparent 70%);
  box-shadow:0 6px 36px rgba(30,100,180,0.1);
  display:flex; align-items:center; justify-content:center; flex-direction:column;
}
.score-num { font-family:'Orbitron',monospace; font-size:34px; font-weight:900; color:var(--accent); line-height:1; }
.score-lbl { font-size:9px; letter-spacing:0.16em; text-transform:uppercase; color:var(--muted); margin-top:4px; }

/* FATIGUE STATUS */
.fatigue-banner {
  display:flex; align-items:center; gap:16px;
  border-radius:14px; padding:20px 24px; margin-bottom:10px;
  border:1.5px solid;
}
.fatigue-banner.stable {
  background:rgba(11,143,114,0.06); border-color:rgba(11,143,114,0.3);
}
.fatigue-banner.warning {
  background:rgba(196,122,10,0.06); border-color:rgba(196,122,10,0.3);
}
.fatigue-banner.fatigued {
  background:rgba(214,50,81,0.06); border-color:rgba(214,50,81,0.3);
}
.fatigue-icon {
  font-size:36px; flex-shrink:0; line-height:1;
}
.fatigue-title {
  font-family:'Orbitron',monospace; font-weight:900;
  font-size:18px; letter-spacing:0.1em; text-transform:uppercase;
  margin-bottom:4px;
}
.fatigue-title.stable  { color:var(--teal); }
.fatigue-title.warning { color:var(--warn); }
.fatigue-title.fatigued{ color:var(--danger); }
.fatigue-desc { font-size:13px; color:var(--muted); line-height:1.6; }
.fatigue-signals {
  display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:12px; margin-top:18px;
}
.signal-row {
  display:flex; align-items:center; gap:10px;
  background:var(--surface2); border:1px solid var(--border);
  border-radius:10px; padding:12px 14px; font-size:12px;
}
.signal-dot {
  width:10px; height:10px; border-radius:50%; flex-shrink:0;
}
.signal-dot.ok   { background:var(--teal); }
.signal-dot.warn { background:var(--warn); }
.signal-dot.bad  { background:var(--danger); }
.signal-label { color:var(--muted); flex:1; }
.signal-val   { font-family:'Space Mono',monospace; font-weight:700; color:var(--text); }

.shiny-html-output table, .shiny-table-output table {
  width:100%; border-collapse:collapse; font-family:'Space Mono',monospace; font-size:13px;
}
.shiny-html-output th, .shiny-table-output th {
  font-size:9.5px; letter-spacing:0.12em; text-transform:uppercase;
  color:var(--muted); padding:9px 14px; border-bottom:1px solid var(--border);
  text-align:left; background:var(--surface2);
}
.shiny-html-output td, .shiny-table-output td {
  padding:11px 14px; border-bottom:1px solid rgba(30,100,180,0.06); color:var(--text);
}
.shiny-html-output tr:hover td, .shiny-table-output tr:hover td {
  background:rgba(30,100,180,0.025);
}
pre.shiny-text-output {
  background:#f2f6fc !important; border:1px solid var(--border) !important;
  border-radius:11px !important; color:#1a3a5c !important;
  font-family:'Space Mono',monospace !important; font-size:13px !important;
  padding:20px !important; margin-bottom:18px !important; line-height:1.7 !important;
}
#downloadReport {
  font-family:'Space Mono',monospace !important; font-size:11px !important;
  letter-spacing:0.07em !important; text-transform:uppercase !important;
  background:var(--purple) !important; color:#fff !important;
  border:none !important; border-radius:9px !important; padding:9px 22px !important;
  box-shadow:0 2px 10px rgba(109,75,191,0.25) !important; transition:all 0.18s !important;
}
#downloadReport:hover {
  background:#5b3db0 !important;
  box-shadow:0 4px 18px rgba(109,75,191,0.35) !important; transform:translateY(-1px) !important;
}
.live-chip {
  display:inline-flex; align-items:center; gap:5px;
  font-size:9.5px; letter-spacing:0.1em; text-transform:uppercase;
  color:var(--teal); background:rgba(11,143,114,0.07);
  border:1px solid rgba(11,143,114,0.2); border-radius:20px; padding:2px 9px; margin-left:10px;
}
.live-dot { width:5px; height:5px; border-radius:50%; background:var(--teal); animation:blink 1.2s ease-in-out infinite; }
@keyframes blink { 0%,100%{opacity:1;} 50%{opacity:.15;} }
::-webkit-scrollbar { width:5px; }
::-webkit-scrollbar-track { background:#eef2f7; }
::-webkit-scrollbar-thumb { background:rgba(30,100,180,0.18); border-radius:3px; }
@media(max-width:640px){
  .shell{padding:0 12px; margin:18px auto;}
  .card{padding:18px 14px;}
}
"

# ─────────────────────────────────────────────────────────────
# UI
# ─────────────────────────────────────────────────────────────
ui <- fluidPage(
  google_fonts,
  tags$head(tags$style(HTML(css))),
  
  div(class = "top-nav",
      div(class = "nav-brand", "CPS", tags$em(" COGNITIVE")),
      div(class = "nav-div"),
      tabsetPanel(id = "tabs", type = "tabs",
                  tabPanel("Reaction",    value = "reaction"),
                  tabPanel("Stroop",      value = "stroop"),
                  tabPanel("Combined",    value = "combined"),
                  tabPanel("Fatigue",     value = "fatigue"),
                  tabPanel("Leaderboard", value = "leaderboard"),
                  tabPanel("Dashboard",   value = "dashboard")
      )
  ),
  
  div(class = "shell",
      
      # REACTION
      conditionalPanel("input.tabs == 'reaction'",
                       div(class = "card",
                           div(class = "sec-label", "Reaction Time Test",
                               span(class = "live-chip", span(class = "live-dot"), "live")
                           ),
                           p(class = "sec-desc",
                             "Wait for the circle to turn green, then click as fast as possible. Measures raw neural response time."),
                           div(class = "reaction-center",
                               uiOutput("game_area"),
                               div(class = "reaction-row",
                                   actionButton("start", "Start", class = "cps-btn cps-btn-blue"),
                                   actionButton("reset", "Reset", class = "cps-btn cps-btn-ghost")
                               )
                           )
                       ),
                       div(class = "card",
                           div(class = "sec-label", "Session Results"),
                           uiOutput("reaction_stats"),
                           tableOutput("results")
                       )
      ),
      
      # STROOP
      conditionalPanel("input.tabs == 'stroop'",
                       div(class = "card card-teal",
                           div(class = "sec-label", "Stroop Interference Task"),
                           p(class = "sec-desc",
                             "Click the COLOR the word is printed in, not what the word says. 3 seconds per trial. Timer only runs while you are on this tab."),
                           uiOutput("stroop_paused_ui"),
                           div(class = "stroop-stage",
                               uiOutput("stroop_word"),
                               div(class = "timer-badge", textOutput("timer_num")),
                               div(class = "stroop-row",
                                   actionButton("red",   "Red"),
                                   actionButton("blue",  "Blue"),
                                   actionButton("green", "Green")
                               ),
                               uiOutput("stroop_result_ui")
                           )
                       ),
                       div(class = "card",
                           div(class = "sec-label", "Accuracy"),
                           div(class = "stat-grid",
                               div(class = "stat-tile", div(class = "stat-big g", textOutput("acc_val")),    div(class = "stat-small", "Accuracy %")),
                               div(class = "stat-tile", div(class = "stat-big",   textOutput("correct_val")),div(class = "stat-small", "Correct")),
                               div(class = "stat-tile", div(class = "stat-big o", textOutput("total_val")),  div(class = "stat-small", "Total Trials"))
                           )
                       )
      ),
      
      # COMBINED
      conditionalPanel("input.tabs == 'combined'",
                       div(class = "card card-purple",
                           div(class = "sec-label", "Cognitive Performance Score"),
                           p(class = "sec-desc",
                             "Combines reaction speed, consistency bonus, and Stroop accuracy into one composite score."),
                           div(class = "score-hero",
                               div(class = "score-ring",
                                   div(class = "score-num", textOutput("score_num")),
                                   div(class = "score-lbl", "Score")
                               ),
                               actionButton("start_combo", "Calculate Score", class = "cps-btn cps-btn-blue")
                           )
                       )
      ),
      
      # FATIGUE
      conditionalPanel("input.tabs == 'fatigue'",
                       div(class = "card card-fatigue",
                           div(class = "sec-label", "Fatigue & Cognitive State Analysis",
                               span(class = "live-chip", span(class = "live-dot"), "auto")
                           ),
                           p(class = "sec-desc",
                             "Automatically analyses your reaction time trend, response consistency, and Stroop accuracy to estimate current cognitive state. Complete at least 4 reaction trials and 4 Stroop trials for a meaningful reading."),
                           uiOutput("fatigue_banner_ui")
                       ),
                       div(class = "card",
                           div(class = "sec-label", "Signal Breakdown"),
                           uiOutput("fatigue_signals_ui")
                       ),
                       div(class = "card",
                           div(class = "sec-label", "Reaction Trend (Early vs Late)"),
                           plotOutput("fatigue_plot", height = "220px")
                       )
      ),
      
      # LEADERBOARD
      conditionalPanel("input.tabs == 'leaderboard'",
                       div(class = "card",
                           div(class = "sec-label", "Top Performers"),
                           tableOutput("leaderboard")
                       )
      ),
      
      # DASHBOARD
      conditionalPanel("input.tabs == 'dashboard'",
                       div(class = "card",
                           div(class = "sec-label", "Performance Summary"),
                           verbatimTextOutput("dashboard")
                       ),
                       div(class = "card",
                           div(class = "sec-label", "Reaction Time Trend"),
                           plotOutput("plot", height = "250px")
                       ),
                       div(class = "card",
                           div(class = "sec-label", "Export"),
                           p(class = "sec-desc", "Download a full HTML report of your current session data, including fatigue analysis."),
                           downloadButton("downloadReport", "Download Report")
                       )
      )
  )
)

# ─────────────────────────────────────────────────────────────
# FATIGUE ANALYSIS HELPER
# ─────────────────────────────────────────────────────────────
analyse_fatigue <- function(times, stroop_correct, stroop_total, stroop_history) {
  result <- list(
    status        = "insufficient",
    label         = "Insufficient Data",
    icon          = "📊",
    description   = "Complete at least 4 reaction trials and 4 Stroop trials for a fatigue reading.",
    rt_trend      = NA, rt_trend_pct = NA, rt_trend_status = "warn",
    cv            = NA, cv_status = "warn",
    acc           = NA, acc_status = "warn",
    acc_trend     = NA, acc_trend_status = "warn",
    fatigue_score = NA
  )
  
  if (length(times) >= 4) {
    n     <- length(times)
    half  <- floor(n / 2)
    early <- mean(times[1:half])
    late  <- mean(times[(half + 1):n])
    trend_pct <- (late - early) / early * 100
    result$rt_trend     <- round((late - early) * 1000, 1)
    result$rt_trend_pct <- round(trend_pct, 1)
    result$rt_trend_status <- if (trend_pct > 15) "bad" else if (trend_pct > 5) "warn" else "ok"
    
    cv <- sd(times) / mean(times) * 100
    result$cv <- round(cv, 1)
    result$cv_status <- if (cv > 25) "bad" else if (cv > 15) "warn" else "ok"
  }
  
  if (stroop_total >= 4) {
    acc <- stroop_correct / stroop_total * 100
    result$acc <- round(acc, 1)
    result$acc_status <- if (acc < 60) "bad" else if (acc < 80) "warn" else "ok"
    
    if (length(stroop_history) >= 6) {
      h_half  <- floor(length(stroop_history) / 2)
      early_a <- mean(stroop_history[1:h_half])
      late_a  <- mean(stroop_history[(h_half + 1):length(stroop_history)])
      result$acc_trend        <- round((late_a - early_a) * 100, 1)
      result$acc_trend_status <- if (result$acc_trend < -10) "bad" else if (result$acc_trend < 0) "warn" else "ok"
    }
  }
  
  if (length(times) >= 4 && stroop_total >= 4) {
    bad_signals <- sum(c(
      result$rt_trend_status == "bad",
      result$cv_status        == "bad",
      result$acc_status       == "bad",
      !is.na(result$acc_trend_status) && result$acc_trend_status == "bad"
    ))
    warn_signals <- sum(c(
      result$rt_trend_status == "warn",
      result$cv_status        == "warn",
      result$acc_status       == "warn",
      !is.na(result$acc_trend_status) && result$acc_trend_status == "warn"
    ))
    
    result$fatigue_score <- bad_signals * 2 + warn_signals
    
    if (bad_signals >= 2 || result$fatigue_score >= 4) {
      result$status      <- "fatigued"
      result$label       <- "Fatigued"
      result$icon        <- "⚠"
      result$description <- "Multiple fatigue signals detected. Your reaction times are slowing and/or accuracy is dropping. Consider taking a break, hydrating, or stopping cognitively demanding tasks."
    } else if (bad_signals == 1 || result$fatigue_score >= 2) {
      result$status      <- "warning"
      result$label       <- "Early Fatigue Signs"
      result$icon        <- "◑"
      result$description <- "Mild fatigue signals present. Some degradation in speed or accuracy detected. Performance is still acceptable but monitor closely."
    } else {
      result$status      <- "stable"
      result$label       <- "Cognitively Stable"
      result$icon        <- "✓"
      result$description <- "No significant fatigue signals detected. Your reaction times and accuracy are consistent. You are performing well."
    }
  }
  
  result
}

# ─────────────────────────────────────────────────────────────
# SERVER
# ─────────────────────────────────────────────────────────────
server <- function(input, output, session) {
  
  # REACTION
  rv <- reactiveValues(times = c(), color = "red", msg = "START", start_time = NULL)
  
  observeEvent(input$start, {
    rv$msg   <- "WAIT..."
    rv$color <- "red"
    later(function() {
      rv$start_time <- Sys.time()
      rv$color      <- "green"
      rv$msg        <- "NOW!"
    }, runif(1, 2, 4))
  })
  
  observeEvent(input$click, {
    if (rv$color == "red") { rv$msg <- "TOO EARLY"; return() }
    rt       <- as.numeric(difftime(Sys.time(), rv$start_time, units = "secs"))
    rv$times <- c(rv$times, rt)
    rv$msg   <- paste0(round(rt * 1000), " ms")
    rv$color <- "red"
  })
  
  observeEvent(input$reset, { rv$times <- c() })
  
  output$game_area <- renderUI({
    cls <- if (rv$color == "green") "go-btn" else ""
    bg  <- if (rv$color == "green")
      "background:rgba(11,143,114,0.06)!important;color:#0b8f72!important;"
    else
      "background:rgba(214,50,81,0.05)!important;color:#d63251!important;"
    actionButton("click", rv$msg, style = bg, class = cls)
  })
  
  output$reaction_stats <- renderUI({
    if (length(rv$times) == 0) return(NULL)
    avg  <- mean(rv$times) * 1000
    best <- min(rv$times)  * 1000
    sdev <- if (length(rv$times) > 1) round(sd(rv$times) * 1000) else "N/A"
    div(class = "stat-grid",
        div(class = "stat-tile", div(class = "stat-big",   round(avg)),  div(class = "stat-small", "Avg (ms)")),
        div(class = "stat-tile", div(class = "stat-big g", round(best)), div(class = "stat-small", "Best (ms)")),
        div(class = "stat-tile", div(class = "stat-big o", sdev),        div(class = "stat-small", "Std Dev (ms)"))
    )
  })
  
  output$results <- renderTable({
    if (length(rv$times) == 0) return()
    data.frame(
      Attempt     = seq_along(rv$times),
      "Time (ms)" = round(rv$times * 1000),
      check.names = FALSE
    )
  })
  
  # STROOP — with per-trial accuracy history
  st <- reactiveValues(
    correct = 0, total = 0, word = NULL, color = NULL, active = FALSE,
    trial_results = c()   # 1 = correct, 0 = wrong/timeout per trial
  )
  timer    <- reactiveVal(3)
  last_res <- reactiveVal("")
  
  stroop_on <- reactive({ isTRUE(input$tabs == "stroop") })
  
  new_trial <- function() {
    words <- c("RED", "BLUE", "GREEN")
    cols  <- c("red", "blue", "green")
    st$word   <- sample(words, 1)
    st$color  <- sample(cols, 1)
    timer(3)
    st$active <- TRUE
    last_res("")
  }
  
  new_trial()
  
  observe({
    if (!stroop_on() || !st$active) return()
    invalidateLater(1000)
    t <- isolate(timer())
    if (t > 0) {
      timer(t - 1)
    } else {
      isolate({
        st$total         <- st$total + 1
        st$trial_results <- c(st$trial_results, 0)
        st$active        <- FALSE
        last_res("TIME OUT")
      })
      later(function() { if (isolate(stroop_on())) new_trial() }, 1)
    }
  })
  
  output$stroop_paused_ui <- renderUI({
    if (stroop_on()) return(NULL)
    div(class = "paused-note", "Timer paused — switch to this tab to play")
  })
  
  output$stroop_word <- renderUI({
    col_hex <- c(red = "#c8334a", blue = "#1e64b4", green = "#0b7a5e")[[st$color]]
    div(class = "stroop-word", style = paste0("color:", col_hex, ";"), st$word)
  })
  
  output$timer_num <- renderText({ timer() })
  
  answer <- function(choice) {
    if (!st$active) return()
    st$total  <- st$total + 1
    st$active <- FALSE
    correct <- (choice == st$color)
    if (correct) {
      st$correct       <- st$correct + 1
      st$trial_results <- c(st$trial_results, 1)
      last_res("CORRECT")
    } else {
      st$trial_results <- c(st$trial_results, 0)
      last_res("WRONG")
    }
    later(new_trial, 1)
  }
  
  observeEvent(input$red,   { answer("red")   })
  observeEvent(input$blue,  { answer("blue")  })
  observeEvent(input$green, { answer("green") })
  
  output$stroop_result_ui <- renderUI({
    r   <- last_res()
    col <- if (r == "CORRECT") "var(--teal)" else if (r == "") "transparent" else "var(--danger)"
    div(class = "verdict", style = paste0("color:", col, ";"), r)
  })
  
  output$acc_val     <- renderText({ if (st$total == 0) "-" else round(st$correct / st$total * 100, 1) })
  output$correct_val <- renderText({ st$correct })
  output$total_val   <- renderText({ st$total })
  
  # FATIGUE REACTIVE
  fatigue_data <- reactive({
    analyse_fatigue(rv$times, st$correct, st$total, st$trial_results)
  })
  
  output$fatigue_banner_ui <- renderUI({
    f <- fatigue_data()
    
    if (f$status == "insufficient") {
      return(div(style = "text-align:center; padding:30px 0; color:var(--muted); font-family:'Space Mono',monospace; font-size:13px;",
                 "Complete at least 4 reaction trials and 4 Stroop trials to get your fatigue reading."))
    }
    
    div(
      div(class = paste("fatigue-banner", f$status),
          div(class = "fatigue-icon", f$icon),
          div(
            div(class = paste("fatigue-title", f$status), f$label),
            div(class = "fatigue-desc", f$description)
          )
      )
    )
  })
  
  output$fatigue_signals_ui <- renderUI({
    f <- fatigue_data()
    
    if (f$status == "insufficient") {
      return(p(style = "color:var(--muted); font-size:13px;", "No signal data yet."))
    }
    
    signal_tile <- function(label, value, status) {
      div(class = "signal-row",
          div(class = paste("signal-dot", status)),
          span(class = "signal-label", label),
          span(class = "signal-val", value)
      )
    }
    
    rt_val  <- if (!is.na(f$rt_trend)) paste0(if (f$rt_trend >= 0) "+" else "", f$rt_trend, " ms") else "N/A"
    cv_val  <- if (!is.na(f$cv))       paste0(f$cv, "%") else "N/A"
    acc_val <- if (!is.na(f$acc))      paste0(f$acc, "%") else "N/A"
    at_val  <- if (!is.na(f$acc_trend)) paste0(if (f$acc_trend >= 0) "+" else "", f$acc_trend, "pp") else "N/A"
    
    div(class = "fatigue-signals",
        signal_tile("RT: early vs late half", rt_val, f$rt_trend_status),
        signal_tile("Response variability (CV)", cv_val, f$cv_status),
        signal_tile("Stroop overall accuracy", acc_val, f$acc_status),
        signal_tile("Stroop accuracy trend", at_val, if (is.na(f$acc_trend_status)) "warn" else f$acc_trend_status)
    )
  })
  
  output$fatigue_plot <- renderPlot({
    if (length(rv$times) < 2) return()
    n    <- length(rv$times)
    half <- floor(n / 2)
    df   <- data.frame(
      x    = seq_len(n),
      y    = rv$times * 1000,
      half = c(rep("Early", half), rep("Late", n - half))
    )
    ggplot(df, aes(x, y, color = half, fill = half)) +
      geom_area(alpha = 0.18, position = "identity") +
      geom_line(linewidth = 1.2) +
      geom_point(size = 3, shape = 21, color = "#ffffff", stroke = 1.8) +
      scale_color_manual(values = c("Early" = "#1e64b4", "Late" = "#d63251")) +
      scale_fill_manual( values = c("Early" = "#1e64b4", "Late" = "#d63251")) +
      scale_x_continuous(breaks = scales::pretty_breaks()) +
      labs(x = "Trial", y = "Reaction Time (ms)", color = "Phase", fill = "Phase") +
      theme_minimal(base_family = "sans") +
      theme(
        plot.background  = element_rect(fill = "#f4f7fb", color = NA),
        panel.background = element_rect(fill = "#f4f7fb", color = NA),
        panel.grid.major = element_line(color = "#dce6f0"),
        panel.grid.minor = element_blank(),
        axis.text        = element_text(color = "#637085", size = 10),
        axis.title       = element_text(color = "#3a5a6a", size = 11),
        legend.background= element_rect(fill = "#f4f7fb", color = NA),
        legend.text      = element_text(color = "#637085", size = 10)
      )
  }, bg = "#f4f7fb")
  
  # SCORING
  lb_data <- reactiveVal(data.frame(Rank = integer(), Player = character(), Score = numeric()))
  
  calc_score <- reactive({
    if (length(rv$times) == 0) return(0)
    acc   <- if (st$total == 0) 0 else st$correct / st$total
    bonus <- if (length(rv$times) > 1 && sd(rv$times) < 0.2) 20 else 0
    round(100 / mean(rv$times) + acc * 100 + bonus, 1)
  })
  
  observeEvent(input$start_combo, {
    s  <- calc_score()
    df <- lb_data()
    df <- rbind(df, data.frame(Rank = NA_integer_, Player = paste0("Player ", nrow(df) + 1), Score = s))
    df <- df[order(-df$Score), ][seq_len(min(10, nrow(df))), ]
    df$Rank <- seq_len(nrow(df))
    lb_data(df)
  })
  
  output$score_num   <- renderText({ calc_score() })
  output$leaderboard <- renderTable({ lb_data() })
  
  # DASHBOARD
  output$dashboard <- renderText({
    if (length(rv$times) == 0) return("No data yet. Complete some tests first.")
    avg  <- round(mean(rv$times) * 1000, 1)
    best <- round(min(rv$times)  * 1000, 1)
    acc  <- if (st$total == 0) "-" else paste0(round(st$correct / st$total * 100, 1), " %")
    f    <- fatigue_data()
    paste0(
      " REACTION TIME\n",
      "   Average  :  ", avg,  " ms\n",
      "   Best     :  ", best, " ms\n",
      "   Trials   :  ", length(rv$times), "\n\n",
      " STROOP TASK\n",
      "   Accuracy :  ", acc, "\n",
      "   Correct  :  ", st$correct, " / ", st$total, "\n\n",
      " COMPOSITE SCORE :  ", calc_score(), "\n\n",
      " COGNITIVE STATE :  ", toupper(f$label)
    )
  })
  
  output$plot <- renderPlot({
    if (length(rv$times) == 0) return()
    df <- data.frame(x = seq_along(rv$times), y = rv$times * 1000)
    ggplot(df, aes(x, y)) +
      geom_area(fill = "#d6e8f7", alpha = 0.7, color = NA) +
      geom_line(color = "#1e64b4", linewidth = 1.3) +
      geom_point(fill = "#1e64b4", color = "#ffffff", size = 3.5, shape = 21, stroke = 2) +
      scale_x_continuous(breaks = scales::pretty_breaks()) +
      labs(x = "Trial", y = "Reaction Time (ms)") +
      theme_minimal(base_family = "sans") +
      theme(
        plot.background  = element_rect(fill = "#f4f7fb", color = NA),
        panel.background = element_rect(fill = "#f4f7fb", color = NA),
        panel.grid.major = element_line(color = "#dce6f0"),
        panel.grid.minor = element_blank(),
        axis.text        = element_text(color = "#637085", size = 10),
        axis.title       = element_text(color = "#3a5a6a", size = 11)
      )
  }, bg = "#f4f7fb")
  
  # REPORT — now includes fatigue section
  output$downloadReport <- downloadHandler(
    filename = function() paste0("cps_report_", format(Sys.time(), "%Y%m%d_%H%M"), ".html"),
    content  = function(file) {
      avg_rt  <- if (length(rv$times) == 0) 0 else mean(rv$times)
      best_rt <- if (length(rv$times) == 0) 0 else min(rv$times)
      acc     <- if (st$total == 0) 0 else st$correct / st$total
      f       <- fatigue_data()
      
      fatigue_color <- switch(f$status,
                              stable     = "#0b7a5e",
                              warning    = "#c47a0a",
                              fatigued   = "#d63251",
                              "#637085"
      )
      fatigue_bg <- switch(f$status,
                           stable     = "rgba(11,143,114,0.06)",
                           warning    = "rgba(196,122,10,0.06)",
                           fatigued   = "rgba(214,50,81,0.06)",
                           "#f4f7fb"
      )
      fatigue_border <- switch(f$status,
                               stable     = "rgba(11,143,114,0.35)",
                               warning    = "rgba(196,122,10,0.35)",
                               fatigued   = "rgba(214,50,81,0.35)",
                               "#ddd"
      )
      
      signal_rows <- ""
      if (f$status != "insufficient") {
        dot_col <- function(s) switch(s, ok = "#0b7a5e", warn = "#c47a0a", bad = "#d63251", "#637085")
        rt_val  <- if (!is.na(f$rt_trend)) paste0(if (f$rt_trend >= 0) "+" else "", f$rt_trend, " ms") else "N/A"
        cv_val  <- if (!is.na(f$cv))       paste0(f$cv, "%") else "N/A"
        av_val  <- if (!is.na(f$acc))      paste0(f$acc, "%") else "N/A"
        at_val  <- if (!is.na(f$acc_trend)) paste0(if (f$acc_trend >= 0) "+" else "", f$acc_trend, "pp") else "N/A"
        
        make_row <- function(label, value, status) {
          paste0("<tr><td style='padding:9px 12px;border-bottom:1px solid #eaeff7;'>",
                 "<span style='display:inline-block;width:9px;height:9px;border-radius:50%;background:", dot_col(status), ";margin-right:8px;'></span>",
                 label, "</td><td style='padding:9px 12px;border-bottom:1px solid #eaeff7;font-weight:700;color:#0f1d2e;'>", value, "</td></tr>")
        }
        signal_rows <- paste0(
          make_row("RT early vs late half",      rt_val, f$rt_trend_status),
          make_row("Response variability (CV)",  cv_val, f$cv_status),
          make_row("Stroop overall accuracy",    av_val, f$acc_status),
          make_row("Stroop accuracy trend",      at_val, if (is.na(f$acc_trend_status)) "warn" else f$acc_trend_status)
        )
      }
      
      html <- paste0(
        "<!DOCTYPE html><html><head><meta charset='UTF-8'>",
        "<title>CPS Report</title><style>",
        "body{font-family:monospace;background:#f2f6fc;color:#0f1d2e;padding:40px;max-width:700px;margin:auto;}",
        "h1{color:#1e64b4;letter-spacing:0.1em;font-size:20px;margin-bottom:6px;}",
        "h2{color:#0b7a5e;font-size:12px;letter-spacing:0.13em;text-transform:uppercase;margin:26px 0 10px;}",
        ".row{display:flex;gap:16px;margin-bottom:16px;flex-wrap:wrap;}",
        ".box{flex:1;min-width:120px;background:#fff;border:1px solid rgba(30,100,180,0.12);border-radius:11px;padding:16px;text-align:center;}",
        ".val{font-size:26px;font-weight:900;color:#1e64b4;margin-bottom:3px;}",
        ".lbl{font-size:9px;letter-spacing:0.12em;text-transform:uppercase;color:#637085;}",
        ".fatigue-box{border-radius:13px;padding:18px 22px;margin-bottom:10px;border:1.5px solid;display:flex;gap:14px;align-items:flex-start;}",
        ".fatigue-icon{font-size:28px;line-height:1;flex-shrink:0;}",
        "table.signals{width:100%;border-collapse:collapse;font-size:13px;background:#fff;border-radius:10px;overflow:hidden;border:1px solid rgba(30,100,180,0.1);}",
        "table.signals th{font-size:9px;letter-spacing:0.12em;text-transform:uppercase;color:#637085;padding:9px 12px;background:#f4f7fb;text-align:left;}",
        "p.note{color:#637085;font-size:11px;margin-top:28px;}",
        "</style></head><body>",
        "<h1>CPS - COGNITIVE PERFORMANCE REPORT</h1>",
        "<p style='color:#637085;font-size:12px;margin-bottom:4px;'>Generated: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "</p>",
        "<h2>Reaction Time</h2><div class='row'>",
        "<div class='box'><div class='val'>", round(avg_rt * 1000), "</div><div class='lbl'>Avg (ms)</div></div>",
        "<div class='box'><div class='val'>", round(best_rt * 1000), "</div><div class='lbl'>Best (ms)</div></div>",
        "<div class='box'><div class='val'>", length(rv$times), "</div><div class='lbl'>Trials</div></div>",
        "</div><h2>Stroop Accuracy</h2><div class='row'>",
        "<div class='box'><div class='val'>", round(acc * 100, 1), "%</div><div class='lbl'>Accuracy</div></div>",
        "<div class='box'><div class='val'>", st$correct, "</div><div class='lbl'>Correct</div></div>",
        "<div class='box'><div class='val'>", st$total, "</div><div class='lbl'>Trials</div></div>",
        "</div><h2>Composite Score</h2>",
        "<div class='row'><div class='box'><div class='val' style='color:#6d4bbf;font-size:32px;'>",
        calc_score(), "</div><div class='lbl'>Final Score</div></div></div>",
        "<h2>Fatigue / Cognitive State</h2>",
        "<div class='fatigue-box' style='background:", fatigue_bg, ";border-color:", fatigue_border, ";'>",
        "<div class='fatigue-icon'>", f$icon, "</div>",
        "<div><div style='font-weight:900;font-size:16px;letter-spacing:0.08em;text-transform:uppercase;color:", fatigue_color, ";margin-bottom:5px;'>",
        f$label, "</div>",
        "<div style='font-size:13px;color:#637085;line-height:1.6;'>", f$description, "</div></div></div>",
        if (nchar(signal_rows) > 0) paste0(
          "<table class='signals'><thead><tr>",
          "<th>Signal</th><th>Value</th></tr></thead><tbody>",
          signal_rows, "</tbody></table>"
        ) else "",
        "<p class='note'>Cognitive Performance System - session report</p>",
        "</body></html>"
      )
      writeLines(html, file)
    }
  )
}

shinyApp(ui, server)