<template>
  <q-card ref="show-summary">
    <q-card-main>
      <p class="row">
        <span class="col-xs-2 col-sm-2 col-md-2 text-bold">{{formattedDateOfShow}}</span>
        <span class="col-xs-3 col-sm-3 col-md-3">{{marketName}}</span>
        <span class="col-xs-3 col-sm-3 col-md-3">{{teamName}}</span>
        <span class="col-xs-3 col-sm-3 col-md-4 row">
          <span class="col-xs-12 col-sm-4 col-md-2 text-bold">Totals:</span>
          <span id="tx-pp-total" class="col-xs-8 col-sm-4 col-md-3 text-center" style="border-bottom:3px solid green;">
            {{formatCurrency(this.currentShow.totalPpSales)}}
          </span>
          <span class="col-xs-2 col-sm-2 col-md-1  text-center">+</span>
          <span id="tx-pl-total" class="col-xs-8 col-sm-4 col-md-2 text-center" style="border-bottom:3px solid blue;">
            {{formatCurrency(this.currentShow.totalPlSales)}}
          </span>
          <span class="col-xs-2 col-sm-2 col-md-1 text-center">=</span>
          <span id="tx-total" class="col-xs-8 col-sm-4 col-md-2 text-center" style="border-bottom:3px double red;">
            {{formatCurrency(this.currentShow.totalSales)}}
          </span>
        </span>
      </p>
    </q-card-main>
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

    computed: {
      formattedDateOfShow () {
        if (this.currentShow.dateOfShow) return date.formatDate(this.currentShow.dateOfShow, 'YYYY-MM-DD')
      },
      marketName () {
        return this.tfpData['markets'][this.currentShow.market].name
      },
      teamName () {
        return this.tfpData['teams'][this.currentShow.teamName].name
      }
    },

    methods: {
      formatCurrency (value) {
        return value.toLocaleString('en-US', { style: 'currency', currency: 'USD' })
      }
    }
  }
</script>
