# Database

Supabase PostgreSQL 스키마 및 마이그레이션 관리

## 환경별 스키마

| 환경 | 스키마 |
|------|--------|
| 로컬 | dev |
| 스테이지 | stage |
| 운영 | prod |

## 마이그레이션 실행

Supabase SQL Editor에서 `migrations/` 폴더의 SQL 파일을 순서대로 실행하세요.

```
001_init_schemas.sql  # 초기 스키마 및 테이블 생성
```

## 새 마이그레이션 추가

파일명 형식: `{번호}_{설명}.sql`

예: `002_add_users_table.sql`
