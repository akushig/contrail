# Contrail

바이브코딩 프로젝트

## 구조

```
apps/web     - Next.js 프론트엔드
apps/api     - Hono 백엔드 (Cloudflare Workers)
packages/shared - 공유 타입/유틸
packages/db  - Drizzle ORM 스키마
```

## 명령어

```bash
npm install          # 의존성 설치
npm run dev          # 개발 서버 실행
npm run build        # 빌드
npm run lint         # 린트
npm run typecheck    # 타입 체크
```

## 로컬 개발

```bash
# PostgreSQL 실행
docker compose -f infra/docker/docker-compose.yml up -d

# 환경변수 설정
cp .env.example .env.local
```

## 환경

- 로컬: Docker PostgreSQL
- 스테이지/운영: Supabase
