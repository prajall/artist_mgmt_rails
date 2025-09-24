export interface User {
  id: number
  first_name: string
  last_name: string
  email: string
  role: 'user' | 'admin' | 'super_admin'
  phone?: string | null
  gender: 'male' | 'female' | 'other' | string
  address?: string | null
  dob?: string | null
  profile_image?: string | null
  created_at: string
  updated_at: string
  password_digest: string
  verified: boolean
}

export interface Artist {
  id: number
  user_id: number
  manager_id: number
  artist_name: string
  first_release_year?: number | null
  no_of_albums_released?: number | null
  created_at: string
  updated_at: string
}

export interface Song {
  id: number
  title: string
  genre: string
  artist_id: number
  created_at: string
  updated_at: string
}
