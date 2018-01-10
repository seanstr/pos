<template>
  <q-modal class="minimized" ref="productTypeModal" v-model="modalOpen" :content-css="{minWidth: '40vw', minHeight: '40vh'}">
    <q-card>
      <q-card-title>
        Product Type
      </q-card-title>
      <q-card-separator />
      <q-card-main ref="product-type">
        <q-field label="Id">
          <q-input v-model="current.id"></q-input>
        </q-field>

        <q-field label="Name">
          <q-input v-model="current.name" placeholder="name of the product type"></q-input>
        </q-field>

        <q-field label="Description">
          <q-input v-model="current.desc" placeholder="description of the product type"></q-input>
        </q-field>

        <q-field label="Image">
          <q-input v-model="current.img" placeholder="image of the product type"></q-input>
        </q-field>

        <q-btn icon-right="save" @click="save()" color="primary">Save</q-btn>
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
    QInput,
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
      QInput,
      QModal,
      QSelect
    },

    props: ['current', 'tfpData', 'modalOpen'],

    data () {
      return {
        productType: {}
      }
    },

    computed: {
    },

    mounted: function () {
      alert('in mounted')
      alert(this.modalOpen)
      if (!this.current) {
        alert(this.current)
        this.current = {
          id: 0,
          name: '',
          desc: '',
          img: '',
          dateCreated: Date.now(),
          dateModified: Date.now()
        }
      }
    },

    methods: {
      open () {
        // this.$refs.productType.open()
      },

      save () {
        alert('in save')
        let _id = Math.max(...Object.keys(this.tfpData.ProductTypes).map(k => this.tfpData.ProductTypes[k]['id']))

        this.productType = {
          id: _id++,
          name: this.current.name,
          desc: this.current.desc,
          img: this.current.img,
          dateCreated: Date.now(),
          dateModified: Date.now()
        }
        this.tfpData.dayInfo[_id] = this.newDayStart

        this.$emit('saved', this.productType)
        this.$refs.productType.close()
      }
    }
  }
</script>
