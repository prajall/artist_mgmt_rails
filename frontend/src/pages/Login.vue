<script lang="ts" setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { z } from 'zod'
import { toTypedSchema } from '@vee-validate/zod'
import { useForm, useField } from 'vee-validate'
import { useAuthstore } from '@/stores/auth'
import axios from 'axios'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader } from '@/components/ui/card'
import { apiRequest } from '@/lib/api'

const loginSchema = z.object({
  email: z.string().email({ message: 'Invalid email' }),
  password: z.string().min(6, 'Password must be at least 6 characters'),
})

type LoginFormData = z.infer<typeof loginSchema>

const router = useRouter()
const authStore = useAuthstore()

const { handleSubmit, errors, setErrors } = useForm<LoginFormData>({
  validationSchema: toTypedSchema(loginSchema),
  initialValues: {
    email: 'superadmin@gmail.com',
    password: 'password',
  },
})

// Use useField for individual field binding
const { value: email } = useField<string>('email')
const { value: password } = useField<string>('password')

const isSubmitting = ref(false)

const onSubmit = handleSubmit(async (data: LoginFormData) => {
  isSubmitting.value = true
  console.log('Submitting', data)

  try {
    const response = await apiRequest.post(`/login/`, {
      email: data.email,
      password: data.password,
    })

    if (response.status === 200) {
      authStore.setUser(response.data.data)
      router.push('/admin')
    }
  } catch (error: any) {
    console.error('Failed to login user:', error)

    if (error.response?.data) {
      const details = error.response.data
      if (typeof details === 'object') {
        const fieldErrors: Record<string, string> = {}
        let hasRootError = false

        Object.entries(details).forEach(([key, value]) => {
          if (key === 'email' || key === 'password') {
            fieldErrors[key] = Array.isArray(value) ? value[0] : (value as string)
          } else {
            fieldErrors.root = Array.isArray(value) ? value[0] : (value as string)
            hasRootError = true
          }
        })

        setErrors(fieldErrors)
      } else {
        setErrors({ root: details || 'Failed to login. Please try again.' })
      }
    } else {
      setErrors({ root: 'Failed to login. Please try again.' })
    }
  } finally {
    isSubmitting.value = false
  }
})
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50">
    <Card class="w-full max-w-md">
      <CardHeader class="text-center">
        <div class="flex flex-col items-center justify-center gap-2 mb-4">
          <p class="text-2xl font-bold m-0">Sign in</p>
          <p class="m-0">Log in to your AMS account</p>
        </div>
      </CardHeader>
      <CardContent>
        <form @submit="onSubmit" class="space-y-4">
          <div>
            <Label for="email">Email</Label>
            <Input
              id="email"
              type="email"
              v-model="email"
              placeholder="Enter your email"
              class="mt-1"
              :class="{ 'border-red-500': errors.email }"
            />
            <p v-if="errors.email" class="text-sm text-red-500 mt-1">
              {{ errors.email }}
            </p>
          </div>

          <div>
            <Label for="password">Password</Label>
            <Input
              id="password"
              type="password"
              v-model="password"
              placeholder="Enter your password"
              class="mt-1"
              :class="{ 'border-red-500': errors.password }"
            />
            <p v-if="errors.password" class="text-sm text-red-500 mt-1">
              {{ errors.password }}
            </p>
          </div>

          <Button type="submit" :disabled="isSubmitting" class="w-full">
            {{ isSubmitting ? 'Signing in...' : 'Sign In' }}
          </Button>

          <p v-if="errors.root" class="text-sm text-red-500">
            {{ errors.root }}
          </p>
        </form>
      </CardContent>
    </Card>
  </div>
</template>
