<template>
  <q-modal class="minimized" ref="dayStart" :content-css="{minWidth: '40vw', minHeight: '40vh'}">
    <q-card>
      <q-card-title>
        Start The Day
      </q-card-title>
      <q-card-separator />
      <q-card-main ref="show-summary">
        <q-field
          icon="today"
          label="Date"
          helper="Helper"
          :error="invalidDate"
          error-label="We need a valid date">
          <q-datetime v-model="currentShow.dateOfShow" type="date" @input="tfpData.markets.dateOfShow" :placeholder="dateOfShow"></q-datetime>
        </q-field>

        <q-field
          icon="today"
          label="Market"
          helper="Helper"
          :error="invalidMarket"
          error-label="We need a valid market">
          <q-select v-model="currentShow.market" :options="locationOptions" placeholder="name of the market"></q-select>
        </q-field>

        <q-field
          icon="today"
          label="Team"
          helper="Helper"
          :error="invalidTeam"
          error-label="We need a valid team">
          <q-select v-model="currentShow.teamName" :options="teamOptions" placeholder="name of the team"></q-select>
        </q-field>

        <q-btn icon-right="save" @click="saveDayStart()" color="primary">Save</q-btn>
        <q-btn icon-right="cancel" @click="$refs.dayStart.close()" color="primary">Close</q-btn>
      </q-card-main>
    </q-card>
  </q-modal>   
</template>
<script>
  import {
    QBtn,
    QCard,
    QCardTitle,
    QCardSeparator,
    QCardMain,
    QField,
    QDatetime,
    QModal,
    QSelect,
    date
  } from 'quasar'

  export default {
    components: {
      QBtn,
      QCard,
      QCardTitle,
      QCardSeparator,
      QCardMain,
      QDatetime,
      QField,
      QModal,
      QSelect
    },

    props: ['currentShow', 'tfpData'],

    data () {
      return {
        dateOfShow: date.formatDate(Date.now(), 'YYYY-MM-DD')
      }
    },

    computed: {
      locationOptions () {
        return this.convertObjectToOptions(this.tfpData.markets)
      },

      teamOptions () {
        return this.convertObjectToOptions(this.tfpData.teams)
      }
    },

    methods: {
      open () {
        this.$refs.dayStart.open()
      },

      saveDayStart () {
        this.$emit('day_saved', this.currentShow)
        this.$refs.dayStart.close()
      },

      convertObjectToOptions: function (obj) {
        return Object.assign([], ...Object.keys(obj).map(k => ({[k]: {label: obj[k].name, value: obj[k].id}}))).filter(Boolean)
      }
    }
  }
</script>
