import { supabase } from '@/lib/supabase'

async function getHealthCheck() {
  const { data, error } = await supabase
    .from('health_check')
    .select('*')
    .limit(1)

  if (error) return { status: 'error', message: error.message }
  if (!data || data.length === 0) return { status: 'error', message: 'No health check data found' }
  return data[0]
}

export default async function Home() {
  const health = await getHealthCheck()

  return (
    <main style={{ padding: '2rem', fontFamily: 'system-ui' }}>
      <h1>Contrail</h1>
      <p>바이브코딩 프로젝트에 오신 것을 환영합니다.</p>

      <div style={{ marginTop: '2rem', padding: '1rem', border: '1px solid #ccc', borderRadius: '8px' }}>
        <h2>Supabase 연결 상태</h2>
        <p>환경: <strong>{process.env.NEXT_PUBLIC_DB_SCHEMA || 'stage'}</strong></p>
        <p>Status: <strong style={{ color: health.status === 'ok' ? 'green' : 'red' }}>{health.status}</strong></p>
        <p>Message: {health.message}</p>
      </div>
    </main>
  )
}
