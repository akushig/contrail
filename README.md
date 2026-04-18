# Contrail

바이브코딩 프로젝트

## 기술 스택

- Frontend: Next.js 15 + React 19
- Backend: Hono (Cloudflare Workers)
- Database: PostgreSQL + Drizzle ORM
- Infra: Docker, Vercel, Cloudflare

## 필수 요구사항

- Node.js 20+
- Docker Desktop

---

## 1. 설치 (최초 1회)

```bash
# 저장소 클론
git clone https://github.com/your-org/contrail.git
cd contrail

# 루트 의존성 설치
npm install

# 프론트엔드 의존성 설치
cd apps/web && npm install && cd ../..

# 환경변수 설정
cp .env.example .env.local
```

## 2. 실행 (매번)

```bash
# 1) PostgreSQL 실행
docker compose -f infra/docker/docker-compose.yml up -d

# 2) 개발 서버 실행
cd apps/web && npm run dev
```

- Frontend: http://localhost:3000
- API: http://localhost:8787 (별도 실행 필요)
- DB: localhost:5433

### 종료

```bash
# 개발 서버: Ctrl+C
# DB 종료
docker compose -f infra/docker/docker-compose.yml down
```

---

## 프로젝트 구조

```
apps/
  web/          # Next.js 프론트엔드
  api/          # Hono 백엔드
packages/
  shared/       # 공유 타입/유틸
  db/           # DB 스키마
docs/           # 문서
infra/          # Docker 설정
```

---

## 배포 설정

### 스테이지 환경 (main 브랜치 푸시 시 자동 배포)

#### Vercel (프론트엔드)
1. [Vercel](https://vercel.com)에서 GitHub 저장소 연결
2. GitHub Secrets 설정:
   - `VERCEL_TOKEN`: Vercel > Settings > Tokens에서 생성
   - `VERCEL_ORG_ID`: Vercel > Settings > General에서 확인
   - `VERCEL_PROJECT_ID`: 프로젝트 Settings > General에서 확인

#### Cloudflare Workers (백엔드)
1. [Cloudflare](https://dash.cloudflare.com)에서 Workers 생성
2. GitHub Secrets 설정:
   - `CF_API_TOKEN`: Cloudflare > My Profile > API Tokens에서 생성 (Workers 권한 필요)

#### Supabase (데이터베이스)
1. [Supabase](https://supabase.com)에서 프로젝트 생성
2. Settings > Database에서 Connection string 복사
3. Cloudflare Workers 환경변수에 `DATABASE_URL` 설정

### 운영 환경 (태그 푸시 시 자동 배포)

```bash
# 운영 배포
git tag v1.0.0
git push origin v1.0.0
```

### GitHub Secrets 요약

| Secret | 용도 | 발급처 |
|--------|------|--------|
| `VERCEL_TOKEN` | Vercel 배포 | Vercel Settings > Tokens |
| `VERCEL_ORG_ID` | Vercel 조직 ID | Vercel Settings > General |
| `VERCEL_PROJECT_ID` | Vercel 프로젝트 ID | Project Settings > General |
| `CF_API_TOKEN` | Cloudflare 배포 | Cloudflare > API Tokens |

---

## 기여하기

[CONTRIBUTING.md](./docs/CONTRIBUTING.md) 참고

## 라이선스

MIT
