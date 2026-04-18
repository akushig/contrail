# Contrail

바이브코딩 프로젝트에 오신 것을 환영합니다.

## 시작하기

### 필수 요구사항

- Node.js 20+
- Docker (로컬 DB용)

### 설치

```bash
npm install
cp .env.example .env.local
```

### 로컬 개발

```bash
# DB 실행
docker compose -f infra/docker/docker-compose.yml up -d

# 개발 서버 실행
npm run dev
```

- 프론트엔드: http://localhost:3000
- API: http://localhost:8787

## 기여하기

[CONTRIBUTING.md](./docs/CONTRIBUTING.md)를 참고해주세요.
