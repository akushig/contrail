-- Contrail 초기 스키마 설정
-- 환경별 스키마 분리: dev, stage, prod

-- 스키마 생성
CREATE SCHEMA IF NOT EXISTS dev;
CREATE SCHEMA IF NOT EXISTS stage;
CREATE SCHEMA IF NOT EXISTS prod;

-- dev 스키마 테이블
CREATE TABLE IF NOT EXISTS dev.health_check (
  id SERIAL PRIMARY KEY,
  status TEXT NOT NULL,
  message TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- stage 스키마 테이블
CREATE TABLE IF NOT EXISTS stage.health_check (
  id SERIAL PRIMARY KEY,
  status TEXT NOT NULL,
  message TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- prod 스키마 테이블
CREATE TABLE IF NOT EXISTS prod.health_check (
  id SERIAL PRIMARY KEY,
  status TEXT NOT NULL,
  message TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 초기 데이터
INSERT INTO dev.health_check (status, message) VALUES ('ok', 'Dev 환경 연결 성공');
INSERT INTO stage.health_check (status, message) VALUES ('ok', 'Stage 환경 연결 성공');
INSERT INTO prod.health_check (status, message) VALUES ('ok', 'Production 환경 연결 성공');

-- RLS 비활성화 (개발 편의를 위해)
ALTER TABLE dev.health_check DISABLE ROW LEVEL SECURITY;
ALTER TABLE stage.health_check DISABLE ROW LEVEL SECURITY;
ALTER TABLE prod.health_check DISABLE ROW LEVEL SECURITY;

-- anon 역할 권한 부여
GRANT USAGE ON SCHEMA dev TO anon, authenticated;
GRANT USAGE ON SCHEMA stage TO anon, authenticated;
GRANT USAGE ON SCHEMA prod TO anon, authenticated;

GRANT ALL ON ALL TABLES IN SCHEMA dev TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA stage TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA prod TO anon, authenticated;

GRANT ALL ON ALL SEQUENCES IN SCHEMA dev TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA stage TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA prod TO anon, authenticated;

-- PostgREST에 스키마 노출 설정
ALTER ROLE authenticator SET pgrst.db_schemas TO 'public, dev, stage, prod';
SELECT pg_reload_conf();
NOTIFY pgrst, 'reload config';
