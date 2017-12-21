<template>
  <div ref="productTypeMaint" v-if="page == 'productTypes'">
    <div id="productTypes" v-for="productType in tfpData.productTypes" v-bind:key="productType.id" >
        <q-card class="row" flat color="light">
            <q-card-main>
            <p class="row">
                <span class="col-xs-2 col-sm-2 col-md-2 text-bold">{{productType.id}}</span>
                <span class="col-xs-3 col-sm-3 col-md-3">{{productType.name}}</span>
                <span class="col-xs-3 col-sm-3 col-md-3">{{productType.desc}}</span>
                <span class="col-xs-3 col-sm-3 col-md-3">{{productType.img}}</span>
            </p>
          </q-card-main>
        </q-card>
    </div>
  </div>
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

    props: ['tfpData'],

    data () {
      return {
        page: 'productTypes'
      }
    },

    computed: {
    },

    methods: {
      open () {
        this.$refs.productTypeMaint.open()
        alert(JSON.stringify(this.tfpData.productTypes))
        this.page = 'productTypes'
        return true
      }
    }
  }
</script>
