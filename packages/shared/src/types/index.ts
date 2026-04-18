export interface ApiResponse<T = unknown> {
  success: boolean
  data?: T
  error?: string
}

export interface User {
  id: string
  email: string
  name: string
  createdAt: Date
}
