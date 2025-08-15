@echo off
setlocal

rem 簡易ビルド用スクリプト
rem Docker Composeを使用して、mp4-repairとphp-webのコンテナをビルド・起動します。
rem 元々のコンテナは自動で削除するため、注意してください。
rem (Windows用)

for %%N in (mp4-repair php-web) do (
  for /F "tokens=*" %%i in ('docker ps -aq -f "name=^/%%N$"') do docker rm -f %%i >nul 2>&1
)

docker compose down -v --remove-orphans

echo [1/3] Build orchestrator image...
cd /d "%~dp0.\orchestrator"
docker build -t mp4-repair-orchestrator .

echo [2/3] Bring down again (double ensure)...
cd /d "%~dp0..\"
docker compose down -v --remove-orphans

echo [3/3] Start compose stack...
docker compose up -d --build --force-recreate --remove-orphans

endlocal
@echo on
