<template>
  <q-modal class="minimized" ref="dayStart" :content-css="{minWidth: '40vw', minHeight: '40vh'}">
    <q-card>
      <q-card-title>
        Start The Day
      </q-card-title>
      <q-card-separator />
      <q-card-main ref="show-summary">
        <q-field label="Date">
          <q-datetime v-model="currentShow.dateOfShow" type="date" @input="tfpData.markets.dateOfShow" default-selection="dateOfShow"></q-datetime>
          <!-- <q-datetime v-model="currentShow.dateOfShow" type="date" @input="tfpData.markets.dateOfShow" :placeholder="dateOfShow"></q-datetime> -->
        </q-field>

        <q-field label="Market">
          <q-select v-model="currentShow.market" :options="locationOptions" placeholder="name of the market"></q-select>
        </q-field>

        <q-field label="Team">
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
    date,
    QBtn,
    QCard,
    QCardTitle,
    QCardSeparator,
    QCardMain,
    QDatetime,
    QField,
    QInlineDatetime,
    QModal,
    QSelect
  } from 'quasar'

  export default {
    components: {
      date,
      QBtn,
      QCard,
      QCardTitle,
      QCardSeparator,
      QCardMain,
      QDatetime,
      QField,
      QInlineDatetime,
      QModal,
      QSelect
    },

    props: ['currentShow', 'tfpData'],

    data () {
      return {
        dateOfShow: date.formatDate(Date.now(), 'YYYY-MM-DD'),
        newDayStart: {}
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
        let _id = Math.max(...Object.keys(this.tfpData.dayInfo).map(k => this.tfpData.dayInfo[k]['id']))

        this.newDayStart = {
          id: _id++,
          marketId: this.currentShow.market,
          showDate: this.currentShow.dateOfShow,
          teamId: this.currentShow.teamName
        }
        this.tfpData.dayInfo[_id] = this.newDayStart

        this.$emit('daySaved', this.currentShow)
        this.$refs.dayStart.close()
      },

      convertObjectToOptions: function (obj) {
        return Object.assign([], ...Object.keys(obj).map(k => ({[k]: {label: obj[k].name, value: obj[k].id}}))).filter(Boolean)
      }
    }
  }
</script>
