<template>
  <q-card ref="show-summary">
      <p class="row">
        <span class="col-3">{{currentShow.dateOfShow}}</span>
        <span class="col-4">{{this.currentShow.market}}</span>
        <span class="col-3">{{this.currentShow.teamName}}</span>
        <span id="tx-total" class="col-2">Total: {{this.currentShow.totalSales}}</span>
      </p>
  </q-card>
</template>
<script>
  import {
    QCard,
    QCardMain
  } from 'quasar'

  export default {
    components: {
      QCard,
      QCardMain
    },
    events: {
      onDayChanged: function (day) {
        this.currentShow = day
      }
    },
    data () {
      return {
        currentShow: { dateOfShow: '', market: '', teamName: '', totalSales: '0' }
      }
    }
  }
</script>
