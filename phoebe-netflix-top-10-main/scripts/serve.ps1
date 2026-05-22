param(
  [int] $Port = 8000
)

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$listener = [System.Net.HttpListener]::new()
$prefix = "http://127.0.0.1:$Port/"
$listener.Prefixes.Add($prefix)
$listener.Start()

Write-Host "Serving $root at $prefix"
Write-Host "Press Ctrl+C to stop."

try {
  while ($listener.IsListening) {
    $context = $listener.GetContext()
    $requestPath = [Uri]::UnescapeDataString($context.Request.Url.AbsolutePath.TrimStart("/"))
    if ([string]::IsNullOrWhiteSpace($requestPath)) {
      $requestPath = "index.html"
    }

    $filePath = Join-Path $root $requestPath
    $resolved = Resolve-Path $filePath -ErrorAction SilentlyContinue

    if ($null -eq $resolved -or -not ($resolved.Path.StartsWith($root.Path))) {
      $context.Response.StatusCode = 404
      $bytes = [Text.Encoding]::UTF8.GetBytes("Not found")
      $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
      $context.Response.Close()
      continue
    }

    $extension = [IO.Path]::GetExtension($resolved.Path).ToLowerInvariant()
    $contentType = switch ($extension) {
      ".html" { "text/html; charset=utf-8" }
      ".json" { "application/json; charset=utf-8" }
      ".js" { "text/javascript; charset=utf-8" }
      ".css" { "text/css; charset=utf-8" }
      default { "application/octet-stream" }
    }

    $bytes = [IO.File]::ReadAllBytes($resolved.Path)
    $context.Response.ContentType = $contentType
    $context.Response.Headers.Add("Cache-Control", "no-store")
    $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    $context.Response.Close()
  }
}
finally {
  $listener.Stop()
  $listener.Close()
}
