<template>
  <div v-if="page == 'transactions'">
    <div v-for="tx in tfpData.transactions" :key="tx.id" id="transactions">
      <q-card class="row" :color="transactionColor(tx)">
        <q-card inline class="col-3 text-dark" flat>
          <q-card-main>
            <div class="row">
              <span class="col-xs-12 col-sm-4 text-bold">Tx#</span>
              <span class="col-xs-6 col-sm-3" style="text-align: right;">{{'00000'+tx.id}}</span>
            </div>
            <div class="row">
              <span class="col-xs-12 col-sm-4 text-bold">Time:</span>
              <span class="col-xs-6 col-sm-3" style="text-align: right;">{{formatTime(tx.txTime)}}</span>
            </div>
            <div class="row">
              <span class="col-xs-12 col-sm-4 text-bold">Tx Total:</span>
              <span class="col-xs-6 col-sm-3" style="text-align: right;">{{formatCurrency(tx.totalNoTax)}}</span>
            </div>
            <div v-if="tx.pp_or_pl == 'pl'" class="row">
              <span class="offset-3" />
              <span class="col-1 text-bold">+</span>
              <span id="tx-tax" class="col-3" style="text-align: right;">{{formatCurrency(tx.tax)}}</span>
            </div>
            <div v-if="tx.pp_or_pl == 'pl'" class="row">
              <span class="offset-3" />
              <span class="col-1 text-bold">=</span>
              <span id="tx-total" class="col-3" style="text-align: right;">{{formatCurrency(tx.total)}}</span>
            </div>
            <div class="row">
              <span class="col">{{tx.pp_or_pl}}</span>
            </div>
          </q-card-main>
        </q-card>

        <q-card inline class="col-7" flat color="light">
          <q-card  class="row" v-for="item in selectedTransactionItems(tx)" v-bind:data="item" v-bind:key="item.productItemDesc" flat color="light">
            <q-card-main class="col-12">
              <div class="row">
                <span class="col-xs-12 col-sm-3 text-bold text-black">Product</span>
                <span class="col-xs-12 col-sm-9 text-black">{{item.productTypeDesc}} - {{item.productItemDesc}}</span>
              </div>
              <div class="row">
                <span class="col-xs-12 col-sm-3  text-bold text-black">Qty</span>
                <span class="col-xs-12 col-sm-2 text-black" style="text-align: left;">{{item.qty}}</span>
              </div>
              <div class="row">
                <span class="col-xs-12 col-sm-3  text-bold text-black">Price</span>
                <span id="tx-total" class="col-xs-12 col-sm-2 text-black" style="text-align: left;">{{formatCurrency(item.price)}}</span>
              </div>
              <div v-if="tx.pp_or_pl == 'pl'" class="row">
                <span class="col-xs-12 col-sm-3  text-bold text-black">Tax</span>
                <span id="tx-total" class="col-xs-12 col-sm-2 text-black" style="text-align: left;">{{formatCurrency(item.tax)}}</span>
              </div>
            </q-card-main>
          </q-card>
        </q-card>
        <q-card inline class="col-xs-12 col-sm-1" flat>
          <div class="row">
            <q-btn class="col-xs-2 col-sm-12" icon="edit" color="primary" small style="width: 100%; margin-top: 10px;" @click="editTransaction(tx)">Edit</q-btn>
            <span class="col-1">&nbsp;</span>
            <q-btn class="col-xs-2 col-sm-12" icon="delete" color="primary" small style="width: 100%; margin-top: 10px;" @click="deleteTransaction(tx)">Delete</q-btn>
          </div>
        </q-card>
      </q-card>
    </div>
  </div>
</template>

<script>
  import {
    QBtn,
    QCard,
    QCardActions,
    QCardMain,
    QCardMedia,
    QCardSeparator,
    QCardTitle
  } from 'quasar'

  export default {
    components: {
      QBtn,
      QCard,
      QCardActions,
      QCardMain,
      QCardMedia,
      QCardSeparator,
      QCardTitle
    },

    props: ['page', 'tfpData'],

    data () {
      return {
        currTx: 0
      }
    },

    computed: {
    },

    methods: {
      transactionColor (tx) {
        if (tx.pp_or_pl === 'pl') return 'blue-2'
        return 'green-2'
      },

      selectedTransactionItems (tx) {
        this.currTx = tx
        if (this.tfpData.transactions === '') return null
        let _obj = this.tfpData.transactionItems
        let _filtered = {}
        Object.keys(_obj).forEach(function (key) {
          if (_obj[key].transactionId === tx.id) {
            _filtered[key] = _obj[key]
          }
        })
        return _filtered
      },

      editTransaction (tx) {
        this.$emit('editTransaction', [tx, this.selectedTransactionItems(tx), 'new-transactions'])
      },

      deleteTransaction (tx) {
        this.$emit('deleteTransaction', [tx])
      },

      formatCurrency (value) {
        return value.toLocaleString('en-US', { style: 'currency', currency: 'USD' })
      },

      formatTime (value) {
        return ('0' + new Date(value).getHours()).slice(-2) + ':' + ('0' + new Date(value).getMinutes()).slice(-2)
      }
    }
  }
</script>