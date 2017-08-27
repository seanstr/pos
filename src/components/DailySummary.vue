<template>
  <q-card ref="show-summary">
      <p class="row">
        <span class="col-3">{{formattedDateOfShow}}</span>
        <span class="col-4">{{marketName}}</span>
        <span class="col-3">{{teamName}}</span>
        <span id="tx-total" class="col-2">Total: {{this.currentShow.totalSales}}</span>
      </p>
  </q-card>
</template>
<script>
  import {
    date,
    QCard,
    QCardMain
  } from 'quasar'

  export default {
    components: {
      date,
      QCard,
      QCardMain
    },
    props: ['currentShow', 'tfpData', 'currentShowId'],
    data () {
      return {
        // currentShow: { dateOfShow: '', market: '', teamName: '', totalSales: '0' }
      }
    },
    computed:
    {
      formattedDateOfShow () {
        if (this.currentShow.dateOfShow) return date.formatDate(this.currentShow.dateOfShow, 'YYYY-MM-DD')
      },
      marketName () {
        return this.tfpData['markets'][this.currentShow.market].name
      },
      teamName () {
        return this.tfpData['teams'][this.currentShow.teamName].name
      }
    }
  }
</script>
