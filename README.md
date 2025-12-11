Proyecto CI/CD Multi-Plataforma
!CI - Continuous Integration
!Security Scan
!Release

Aplicación Express con integración continua y despliegue automatizado usando GitHub Actions.

Enlaces directos a los Actions:

	* CI Pipeline: https://github.com/AbrahamRP97/so-github-actions-labs/actions/workflows/ci.yml
	* Security Scan: https://github.com/AbrahamRP97/so-github-actions-labs/actions/workflows/security-scan.yml
	* Release & Deploy: https://github.com/AbrahamRP97/so-github-actions-labs/actions/workflows/release.yml
	* Página general de Actions del repo: https://github.com/AbrahamRP97/so-github-actions-labs/actions

Rutas:

	* / → Información del entorno
	* /info → Estado del servidor
	* /time → Hora actual

Workflows:

	* CI Pipeline: pruebas en Linux, Windows y macOS
	* Security Scan: auditoría de dependencias y permisos
	* Release & Deploy: release automático y despliegue en Vercel

Comandos:

npm test
npm run test:coverage

Estructura principal:

server.js
app/tests/server.test.js
.github/workflows/

Autor: Abraham Rivera
