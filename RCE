<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Web" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Upload Execution Test (Safe)</title>
    <style>
        body { font-family: Segoe UI, Arial; margin:20px; }
        pre { background:#f6f6f6; padding:12px; border-radius:6px; white-space:pre-wrap; }
        .warn { color:#b33; font-weight:bold; }
    </style>
</head>
<body>
    <h2>Upload Execution Test (Safe)</h2>
    <p class="warn">This page is intentionally safe: it does <strong>not</strong> execute arbitrary OS commands or open network shells.</p>

<%
    // Simple token to prevent accidental public viewing - change when testing
    const string VIEW_TOKEN = "ctf-test-token";

    string token = Request.QueryString["token"] ?? "";
    bool allowed = (token == VIEW_TOKEN);

    string result = "";
    try
    {
        // Create App_Data marker (safe write to app folder)
        string appData = Server.MapPath("~/App_Data");
        if (!Directory.Exists(appData)) Directory.CreateDirectory(appData);

        string marker = Path.Combine(appData, "upload_marker.txt");
        File.AppendAllText(marker, $"Executed at {DateTime.UtcNow:O} from {Request.UserHostAddress}\n");

        result += "Wrote marker to App_Data/upload_marker.txt\n\n";

        if (allowed)
        {
            // Safe environment info
            result += "=== Environment (safe) ===\n";
            result += "MachineName: " + Environment.MachineName + "\n";
            result += "Process user (Environment.UserName): " + Environment.UserName + "\n";
            result += ".NET version: " + Environment.Version.ToString() + "\n";
            result += "App root (mapped): " + Server.MapPath("~/") + "\n\n";

            // List files in the application root (safe listing, no file contents)
            result += "=== Files in app root (safe listing) ===\n";
            string root = Server.MapPath("~/");
            try
            {
                var files = Directory.GetFiles(root);
                foreach (var f in files)
                {
                    FileInfo fi = new FileInfo(f);
                    result += $"{fi.Name}\t{fi.Length} bytes\n";
                }
            }
            catch (Exception ex)
            {
                result += "Could not enumerate files: " + ex.Message + "\n";
            }
        }
        else
        {
            result += "To view environment info, append ?token=ctf-test-token to the URL.\n";
        }
    }
    catch (Exception ex)
    {
        result += "Error: " + HttpUtility.HtmlEncode(ex.Message) + "\n";
    }
%>

    <pre><%= HttpUtility.HtmlEncode(result) %></pre>

    <hr/>
    <p>Notes:</p>
    <ul>
        <li>Only use in an isolated VM / dedicated CTF target.</li>
        <li>This file is safe and intended solely to verify server-side execution.</li>
        <li>It will <em>not</em> give you a shell or let you run arbitrary system commands.</li>
    </ul>
</body>
</html>
