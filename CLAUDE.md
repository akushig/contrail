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

- 로컬: Docker PostgreSQL (port 5433)
- 스테이지/운영: Supabase

## 배포 규칙

- `main` 브랜치 푸시 → 스테이지 자동 배포
- `v*` 태그 푸시 → 운영 자동 배포 (예: `git tag v1.0.0 && git push origin v1.0.0`)
- 운영 배포 전 반드시 스테이지에서 테스트 완료할 것
- 태그는 시맨틱 버저닝 사용: `v{major}.{minor}.{patch}`

## 브랜치 전략

- `main`: 기본 브랜치, 스테이지 배포 대상
- 기능 개발: `feature/기능명` 브랜치에서 작업 후 PR → main 머지
- 버그 수정: `fix/버그명` 브랜치에서 작업 후 PR → main 머지
- 직접 main에 푸시 금지, 반드시 PR을 통해 머지

## 코드 작성 규칙

### TDD (테스트 주도 개발)
1. 테스트 코드 먼저 작성 (Red)
2. 테스트 통과하는 최소 코드 작성 (Green)
3. 리팩토링 (Refactor)
- 새 기능/버그 수정 시 반드시 테스트부터 작성

### DDD + 클린 아키텍처
```
src/
  domain/        # 엔티티, 값 객체, 도메인 서비스 (비즈니스 로직)
  application/   # 유스케이스, 애플리케이션 서비스
  infrastructure/ # DB, 외부 API, 프레임워크 구현체
  presentation/  # 컨트롤러, API 라우트
```
- 의존성 방향: presentation → application → domain ← infrastructure
- domain은 외부 의존성 없이 순수 비즈니스 로직만
- infrastructure는 domain 인터페이스를 구현
