document.getElementById("refreshBtn").addEventListener("click", async () => {
  const message = document.getElementById("message");

  try {
    const response = await fetch("http://localhost:4001/api/logs");
    const data = await response.json();

    const incidents = data.incidents || [];
    const latest = incidents[0] || null;

    message.textContent = latest
      ? `Total errors: ${data.totalErrors} | Latest: ${latest.timestamp}`
      : "No log data found";

    message.style.background = "#14532d";
    message.style.color = "#dcfce7";
  } catch (error) {
    console.error("Error fetching logs:", error);
    message.textContent = "Backend unavailable";
    message.style.background = "#7f1d1d";
    message.style.color = "#fee2e2";
  }
});