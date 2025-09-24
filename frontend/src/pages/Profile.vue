<script setup lang="ts">
import UserProfile from '@/components/UserProfile.vue'
import { useAuthstore } from '@/stores/auth'

const { user } = useAuthstore()
</script>

<template>
  <UserProfile :user="user!" />
</template>
