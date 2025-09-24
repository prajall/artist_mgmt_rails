<script setup lang="ts">
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { CalendarDays, Mail, MapPin, Phone, User as UserIcon, UserCircle2 } from 'lucide-vue-next'
import type { User } from '@/types/types'

interface Props {
  user: User
}

const props = defineProps<Props>()

const SERVER_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000'

const formatDate = (dateString: string): string => {
  return new Date(dateString).toLocaleDateString()
}
</script>

<template>
  <Card class="mx-auto shadow-lg">
    <CardContent class="p-8">
      <div class="flex flex-col sm:flex-row items-center sm:items-start gap-8 border-b pb-6">
        <Avatar class="h-28 w-28 border-2 border-gray-200">
          <AvatarImage
            v-if="user.profile_image"
            :src="SERVER_BASE_URL + user.profile_image"
            :alt="`${user.first_name} ${user.last_name}`"
            class="object-cover"
          />
          <AvatarFallback v-else class="text-2xl font-semibold bg-gray-100">
            {{ user.first_name[0]?.toUpperCase() }}{{ user.last_name[0]?.toUpperCase() }}
          </AvatarFallback>
        </Avatar>

        <div class="flex-1 text-center sm:text-left">
          <h1 class="text-3xl font-bold text-gray-900">
            {{ user.first_name }} {{ user.last_name }}
          </h1>
          <div class="mt-2">
            <Badge variant="secondary" class="capitalize">
              {{ user.role }}
            </Badge>
          </div>
          <p class="text-sm text-gray-500 mt-2">Member since {{ formatDate(user.created_at) }}</p>
        </div>
      </div>

      <div class="grid md:grid-cols-2 gap-8 mt-8">
        <div>
          <h2 class="text-lg font-semibold text-gray-900 mb-4">Contact Information</h2>
          <div class="space-y-3">
            <div class="flex items-center gap-3">
              <Mail class="h-4 w-4 text-gray-500" />
              <span class="text-gray-900 font-medium">Email:</span>
              <span class="text-gray-700">{{ user.email }}</span>
            </div>

            <div v-if="user.phone" class="flex items-center gap-3">
              <Phone class="h-4 w-4 text-gray-500" />
              <span class="text-gray-900 font-medium">Phone:</span>
              <span class="text-gray-700">{{ user.phone }}</span>
            </div>

            <div v-if="user.address" class="flex items-center gap-3">
              <MapPin class="h-4 w-4 text-gray-500" />
              <span class="text-gray-900 font-medium">Address:</span>
              <span class="text-gray-700">{{ user.address }}</span>
            </div>
          </div>
        </div>

        <div v-if="user.gender || user.dob">
          <h2 class="text-lg font-semibold text-gray-900 mb-4">Personal Information</h2>
          <div class="space-y-3">
            <div v-if="user.gender" class="flex items-center gap-3">
              <UserCircle2 class="h-4 w-4 text-gray-500" />
              <span class="text-gray-900 font-medium">Gender:</span>
              <span class="capitalize text-gray-700">
                {{ user.gender }}
              </span>
            </div>

            <div v-if="user.dob" class="flex items-center gap-3">
              <CalendarDays class="h-4 w-4 text-gray-500" />
              <span class="text-gray-900 font-medium">Date of Birth:</span>
              <span class="text-gray-700">
                {{ formatDate(user.dob) }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </CardContent>
  </Card>
</template>
