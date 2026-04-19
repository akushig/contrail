# Contrail

바이브코딩 프로젝트

---

## 필수 설치 프로그램

로컬 개발을 위해 아래 프로그램들을 먼저 설치하세요.

| 프로그램 | 용도 | 필요 환경 | 설치 방법 |
|----------|------|-----------|-----------|
| **Node.js 20+** | JavaScript 실행 환경 | 로컬 | https://nodejs.org 에서 LTS 버전 다운로드 |
| **Git** | 소스코드 버전 관리 | 로컬 | https://git-scm.com 에서 다운로드 |
| **Docker Desktop** | 로컬 DB 실행 (선택) | 로컬 | https://docker.com 에서 다운로드 |
| **GitHub CLI** | GitHub 작업 자동화 | 로컬/CI | `brew install gh` (Mac) 또는 https://cli.github.com |

> Docker는 로컬에서 PostgreSQL을 실행할 때만 필요합니다. Supabase 클라우드 DB를 사용하면 Docker 없이도 개발 가능합니다.

---

## 기술 스택

| 영역 | 기술 | 설명 |
|------|------|------|
| 프론트엔드 | Next.js 15 + React 19 | 웹 UI 프레임워크 |
| 백엔드 | Hono | 경량 API 서버 (Cloudflare Workers에서 실행) |
| 데이터베이스 | PostgreSQL + Supabase | 관계형 DB, 클라우드 호스팅 |
| 배포 | Vercel, Cloudflare Workers | 프론트엔드/백엔드 호스팅 |
| CI/CD | GitHub Actions | 자동 테스트 및 배포 |

---

## 프로젝트 구조

```
contrail/
├── apps/
│   ├── web/              # Next.js 프론트엔드
│   └── api/              # Hono 백엔드 (Cloudflare Workers)
├── packages/
│   ├── shared/           # 공유 타입/유틸
│   └── db/               # DB 스키마 및 마이그레이션
├── docs/                 # 문서
├── infra/                # Docker 설정
├── .github/workflows/    # CI/CD 파이프라인
├── .env.example          # 환경변수 템플릿
├── CLAUDE.md             # AI 코딩 도구용 컨텍스트
└── README.md             # 이 파일
```

---

## 환경별 구성

| 환경 | 프론트엔드 | 백엔드 | DB 스키마 | 용도 |
|------|-----------|--------|-----------|------|
| 로컬 | localhost:3000 | localhost:8787 | `dev` | 개인 개발 |
| 스테이지 | Vercel Preview | Cloudflare Workers | `stage` | PR 테스트 |
| 운영 | Vercel Production | Cloudflare Workers | `prod` | 실제 서비스 |

---

## 1. 최초 설정 (한 번만)

### 1-1. 저장소 클론

```bash
git clone https://github.com/akushig/contrail.git
cd contrail
```

### 1-2. 의존성 설치

```bash
# 루트 의존성 설치
npm install

# 프론트엔드 의존성 설치
cd apps/web && npm install && cd ../..
```

### 1-3. 환경변수 설정

```bash
# 프론트엔드 환경변수
cp apps/web/.env.example apps/web/.env.local
```

`apps/web/.env.local` 파일을 열고 Supabase 정보를 입력하세요:

```
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
NEXT_PUBLIC_DB_SCHEMA=dev
```

> Supabase URL과 Key는 Supabase 대시보드 > Settings > API에서 확인할 수 있습니다.

### 1-4. 데이터베이스 설정 (Supabase)

1. [Supabase](https://supabase.com)에서 프로젝트 생성
2. SQL Editor에서 `packages/db/migrations/001_init_schemas.sql` 내용 실행
3. 위 환경변수에 URL과 Key 입력

---

## 2. 개발 서버 실행 (매번)

```bash
# 프론트엔드 개발 서버 실행
cd apps/web
npm run dev
```

브라우저에서 http://localhost:3000 접속

> 개발 서버는 별도 터미널에서 실행하세요. Ctrl+C로 종료합니다.

### (선택) 로컬 PostgreSQL 사용 시

Docker Desktop이 실행 중인 상태에서:

```bash
# DB 시작
docker compose -f infra/docker/docker-compose.yml up -d

# DB 종료
docker compose -f infra/docker/docker-compose.yml down
```

---

## 3. 브랜치 전략 및 작업 흐름

### 브랜치 규칙

| 브랜치 | 용도 | 배포 대상 |
|--------|------|-----------|
| `main` | 기본 브랜치 | 스테이지 자동 배포 |
| `feature/기능명` | 새 기능 개발 | - |
| `fix/버그명` | 버그 수정 | - |

### 작업 흐름

```bash
# 1. 새 브랜치 생성
git checkout -b feature/로그인기능

# 2. 작업 후 커밋 (한글로 작성)
git add .
git commit -m "로그인 폼 UI 추가"

# 3. 원격에 푸시
git push origin feature/로그인기능

# 4. GitHub에서 Pull Request 생성 → main으로 머지
```

> main 브랜치에 직접 푸시하지 마세요. 반드시 PR을 통해 머지합니다.

---

## 4. 배포

### 스테이지 배포 (자동)

main 브랜치에 PR이 머지되면 자동으로 스테이지 환경에 배포됩니다.

### 운영 배포 (수동)

```bash
# 태그 생성 및 푸시
git tag v1.0.0
git push origin v1.0.0
```

GitHub에서 배포 승인 후 운영 환경에 배포됩니다.

> 태그 형식: `v{major}.{minor}.{patch}` (예: v1.0.0, v1.1.0, v2.0.0)

---

## 5. 외부 서비스 설정 (관리자용)

CI/CD 파이프라인이 동작하려면 아래 설정이 필요합니다.

### GitHub Secrets

GitHub 저장소 > Settings > Secrets and variables > Actions에서 설정:

| Secret | 용도 | 필요 환경 | 발급 방법 |
|--------|------|-----------|-----------|
| `VERCEL_TOKEN` | Vercel 배포 인증 | CI/CD | Vercel > Settings > Tokens > Create |
| `VERCEL_ORG_ID` | Vercel 조직 식별 | CI/CD | Vercel > Settings > General |
| `VERCEL_PROJECT_ID` | Vercel 프로젝트 식별 | CI/CD | Vercel 프로젝트 > Settings > General |
| `CF_API_TOKEN` | Cloudflare 배포 인증 | CI/CD | Cloudflare > My Profile > API Tokens |
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase 연결 | CI/CD | Supabase > Settings > API |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase 인증 | CI/CD | Supabase > Settings > API |

### Vercel 환경변수

Vercel 대시보드 > 프로젝트 > Settings > Environment Variables에서 설정:

| 변수 | Preview 값 | Production 값 |
|------|------------|---------------|
| `NEXT_PUBLIC_SUPABASE_URL` | (Supabase URL) | (동일) |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | (Supabase Key) | (동일) |
| `NEXT_PUBLIC_DB_SCHEMA` | `stage` | `prod` |

### GitHub 환경 승인 설정

운영 배포 시 승인이 필요하도록 설정:

1. GitHub 저장소 > Settings > Environments
2. `production` 환경 생성
3. "Required reviewers" 활성화 후 승인자 지정

---

## 6. 자주 쓰는 명령어

```bash
npm run dev          # 개발 서버 실행
npm run build        # 빌드
npm run lint         # 코드 스타일 검사
npm run typecheck    # 타입 검사
npm run test         # 테스트 실행
```

---

## 7. 문제 해결

### 포트 충돌 (3000 already in use)

```bash
# 기존 프로세스 종료
lsof -ti:3000 | xargs kill -9
```

### node_modules 문제

```bash
# 의존성 재설치
rm -rf node_modules apps/web/node_modules
npm install
cd apps/web && npm install
```

### Supabase 연결 오류

1. `.env.local` 파일의 URL과 Key가 올바른지 확인
2. Supabase 대시보드에서 프로젝트가 활성 상태인지 확인
3. 스키마(dev/stage/prod)가 생성되어 있는지 확인

---

## 라이선스

MIT
