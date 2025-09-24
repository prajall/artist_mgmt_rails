<template>
  <div class="form-container">
    <h2>User Registration</h2>

    <form @submit="onSubmit" class="registration-form">
      <!-- Email Field -->
      <div class="field-group">
        <label for="email">Email Address *</label>
        <input
          id="email"
          v-model="email"
          type="email"
          :class="{ 'field-error': errors.email }"
          placeholder="Enter your email"
        />
        <span v-if="errors.email" class="error-text">{{ errors.email }}</span>
      </div>

      <!-- Password Field -->
      <div class="field-group">
        <label for="password">Password *</label>
        <input
          id="password"
          v-model="password"
          type="password"
          :class="{ 'field-error': errors.password }"
          placeholder="Enter your password"
        />
        <span v-if="errors.password" class="error-text">{{ errors.password }}</span>
      </div>

      <!-- Confirm Password Field -->
      <div class="field-group">
        <label for="confirmPassword">Confirm Password *</label>
        <input
          id="confirmPassword"
          v-model="confirmPassword"
          type="password"
          :class="{ 'field-error': errors.confirmPassword }"
          placeholder="Confirm your password"
        />
        <span v-if="errors.confirmPassword" class="error-text">{{ errors.confirmPassword }}</span>
      </div>

      <!-- Age Field -->
      <div class="field-group">
        <label for="age">Age *</label>
        <input
          id="age"
          v-model.number="age"
          type="number"
          :class="{ 'field-error': errors.age }"
          placeholder="Enter your age"
        />
        <span v-if="errors.age" class="error-text">{{ errors.age }}</span>
      </div>

      <!-- Terms Checkbox -->
      <div class="field-group">
        <label class="checkbox-label">
          <input v-model="terms" type="checkbox" :class="{ 'field-error': errors.terms }" />
          I accept the terms and conditions *
        </label>
        <span v-if="errors.terms" class="error-text">{{ errors.terms }}</span>
      </div>

      <!-- Submit Button -->
      <button type="submit" :disabled="!isValid || isSubmitting" class="submit-btn">
        {{ isSubmitting ? 'Creating Account...' : 'Create Account' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { useForm, useField } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/zod'
import { z } from 'zod'
import { ref } from 'vue'

// Zod validation schema
const validationSchema = z
  .object({
    email: z
      .string({ required_error: 'Email is required' })
      .email('Please enter a valid email address'),

    password: z
      .string({ required_error: 'Password is required' })
      .min(8, 'Password must be at least 8 characters')
      .regex(/[A-Z]/, 'Password must contain at least one uppercase letter')
      .regex(/[0-9]/, 'Password must contain at least one number'),

    confirmPassword: z.string({ required_error: 'Please confirm your password' }),

    age: z
      .number({ required_error: 'Age is required' })
      .min(18, 'Must be at least 18 years old')
      .max(120, 'Please enter a valid age'),

    terms: z.boolean().refine((val) => val === true, {
      message: 'You must accept the terms and conditions',
    }),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: 'Passwords do not match',
    path: ['confirmPassword'],
  })

// Setup form with Zod schema
const { handleSubmit, errors, isValid } = useForm({
  validationSchema: toTypedSchema(validationSchema),
})

// Setup individual fields
const { value: email } = useField('email')
const { value: password } = useField('password')
const { value: confirmPassword } = useField('confirmPassword')
const { value: age } = useField('age')
const { value: terms } = useField('terms')

// Submission state
const isSubmitting = ref(false)

// Form submission handler
const onSubmit = handleSubmit(async (values) => {
  isSubmitting.value = true

  try {
    // Simulate API call
    await new Promise((resolve) => setTimeout(resolve, 2000))

    console.log('Registration successful:', values)
    alert('Account created successfully!')
  } catch (error) {
    console.error('Registration failed:', error)
    alert('Registration failed. Please try again.')
  } finally {
    isSubmitting.value = false
  }
})
</script>

<style scoped>
.form-container {
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
}

.registration-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.field-group {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

label {
  font-weight: bold;
  color: #333;
}

input[type='email'],
input[type='password'],
input[type='number'] {
  padding: 10px;
  border: 2px solid #ddd;
  border-radius: 4px;
  font-size: 16px;
}

input.field-error {
  border-color: #e74c3c;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: normal;
}

.error-text {
  color: #e74c3c;
  font-size: 14px;
}

.submit-btn {
  padding: 12px;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
}

.submit-btn:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}

.submit-btn:hover:not(:disabled) {
  background-color: #2980b9;
}
</style>
