const {MongoClient, ObjectId} = require("mongodb");

const mongoClient = new MongoClient("mongodb://localhost:27017/");

async function run() {
    try {
        await mongoClient.connect()
        const db = mongoClient.db("database")
        const collection = db.collection("lab8")
        await collection.deleteMany({})

        // 3.1 Отобразить коллекции базы данных
        const collections = await db.collections()
        console.log('Доступные коллекции: ', collections.map(x => x.collectionName))

        // 3.2 Вставка записей
        // 3.2.1 Вставка одной записи insertOne
        await collection.insertOne({
            country_code: '7',
            number: '96*778*0**',
            active_balance_in_kopecks: 100,
            internet_packet_in_megabytes: 30000,
            available_minutes_in_seconds: 180000,
            user: {
                first_name: 'Yaroslav',
                last_name: '',
                patronymic: '',
                passport_data: {
                    series: '',
                    number: '',
                    issuing_authority: '',
                    data_issue: new Date(2016, 4, 16),
                },
            },
            payment: [
                {
                    amount_in_kopecks: 5000,
                    date: new Date(2022, 1, 1, 0, 0),
                    operation_token: '1234567891011121314151617181920',
                    is_successfully: true,
                },
                {
                    amount_in_kopecks: 3000,
                    date: new Date(2022, 2, 1, 0, 0),
                    operation_token: '1234567891011121314151617182020',
                    is_successfully: true,
                },
            ],
            type_service: [
                {
                    name: 'Безлимит',
                    description: '',
                    subscription_fee_in_kopecks: 0,
                    is_deactivable: false,
                },
            ],
        })
        // 3.2.2 Вставка нескольких записей insertMany
        await collection.insertMany([
            {
                country_code: '7',
                number: '96*778*8**',
                active_balance_in_kopecks: 500,
                internet_packet_in_megabytes: 10000,
                available_minutes_in_seconds: 10000,
                user: {
                    first_name: 'Kirill',
                    last_name: '',
                    passport_data: {
                        series: '',
                        number: '',
                        issuing_authority: '',
                        data_issue: new Date(2016, 2, 28),
                    },
                },
                payment: [
                    {
                        amount_in_kopecks: 2000,
                        date: new Date(2022, 1, 1, 12, 0),
                        operation_token: '1234567891011121314151617181921',
                        is_successfully: true,
                    },
                ],
                type_service: [
                    {
                        name: 'Безлимит',
                        description: '',
                        subscription_fee_in_kopecks: 0,
                        is_deactivable: false,
                    },
                ],
            },
            {
                country_code: '380',
                number: '96*778*2**',
                active_balance_in_kopecks: 1000,
                internet_packet_in_megabytes: 20000,
                available_minutes_in_seconds: 120000,
                user: {
                    first_name: 'Vasiliy',
                    last_name: '',
                    patronymic: '',
                    passport_data: {
                        series: '',
                        number: '',
                        issuing_authority: '',
                        data_issue: new Date(2015, 6, 22),
                    },
                },
                payment: [
                    {
                        amount_in_kopecks: 12000,
                        date: new Date(2022, 1, 2, 0, 0),
                        operation_token: '1234567891011121314151617181922',
                        is_successfully: true,
                    },
                ],
                type_service: [
                    {
                        name: 'Безлимит',
                        description: '',
                        subscription_fee_in_kopecks: 10000,
                        is_deactivable: true,
                    },
                ],
            },
            {
                country_code: '48',
                number: '96*778*2**',
                active_balance_in_kopecks: 100,
                internet_packet_in_megabytes: 200,
                available_minutes_in_seconds: 300,
                user: {
                    first_name: 'Lena',
                    last_name: '',
                    patronymic: '',
                    passport_data: {
                        series: '',
                        number: '',
                        issuing_authority: '',
                        data_issue: new Date(2020, 5, 28),
                    },
                },
                payment: [
                    {
                        amount_in_kopecks: 20000,
                        date: new Date(2022, 1, 2, 12, 0),
                        operation_token: '1234567891011121314151617181923',
                        is_successfully: true,
                    },
                ],
                type_service: [
                    {
                        name: 'Безлимит',
                        description: '',
                        subscription_fee_in_kopecks: 100000,
                        is_deactivable: true,
                    },
                ],
            },
            {
                country_code: '48',
                number: '96*778*2**',
                active_balance_in_kopecks: 150,
                internet_packet_in_megabytes: 250,
                available_minutes_in_seconds: 350,
                user: {
                    first_name: 'Zuzanna',
                    last_name: '',
                    patronymic: '',
                    passport_data: {
                        series: '',
                        number: '',
                        issuing_authority: '',
                        data_issue: new Date(2021, 5, 28),
                    },
                },
                payment: [
                    {
                        amount_in_kopecks: 12000,
                        date: new Date(2022, 1, 3, 0, 0),
                        operation_token: '1234567891011121314151617181924',
                        is_successfully: true,
                    },
                ],
                type_service: [
                    {
                        name: 'Безлимит',
                        description: '',
                        subscription_fee_in_kopecks: 100000,
                        is_deactivable: true,
                    },
                ],
            },
        ])

        // 3.3 Удаление записей
        // 3.3.1 Удаление одной записи по условию deleteOne
        await collection.deleteOne({country_code: '380'})
        // 3.3.2 Удаление нескольких записей по условию deleteMany
        await collection.deleteMany({country_code: '48'})

        // 3.4 Поиск записей
        console.log('Поиск: ')
        // 3.4.1 Поиск по ID
        console.log('По ID: ', await collection.findOne({_id: ObjectId('6291fb9aa1466c59c0db7df3')}))
        // 3.4.2 Поиск записи по атрибуту первого уровня
        console.log('По атрибуту первого уровня: ', await collection.findOne({active_balance_in_kopecks: 500}))
        // 3.4.3 Поиск записи по вложенному атрибуту
        console.log('По вложенному атрибуту: ', await collection.findOne({'user.first_name': 'Yaroslav'}))
        // 3.4.4 Поиск записи по нескольким атрибутам (логический оператор AND)
        console.log('По нескольким атрибутам (AND): ', await collection.findOne({$and: [{country_code: '7'}, {available_minutes_in_seconds: 180000}]}))
        // 3.4.5 Поиск записи по нескольким атрибутам (логический оператор OR)
        console.log('По нескольким атрибутам (OR): ', await collection.findOne({$or: [{active_balance_in_kopecks: 200}, {internet_packet_in_megabytes: 10000}]}))
        // 3.4.6 Поиск с использованием оператора сравнения
        console.log('С использованием оператора сравнения: ', await collection.findOne({internet_packet_in_megabytes: {$gt: 20000}}))
        // 3.4.7 Поиск с использованием двух операторов сравнения
        console.log('С использованием двух операторов сравнения: ', await collection.findOne({available_minutes_in_seconds: {$gt: 150000, $lt: 200000}}))
        // 3.4.8 Поиск по значению в массиве
        console.log('По значению в массиве: ', await collection.findOne({payment: {$elemMatch: {amount_in_kopecks: 5000}}}))
        // 3.4.9 Поиск по количеству элементов в массиве
        console.log('По количеству элементов в массиве: ', await collection.findOne({payment: {$size: 2}}))
        // 3.4.10 Поиск записей без атрибута
        console.log('Без атрибута: ', await collection.findOne({'user.patronymic': {$exists: false}}))

        // 3.5 Обновление записей
        // 3.5.1 Изменить значение атрибута у записи
        await collection.updateOne({active_balance_in_kopecks: {$lt: 200}}, {$set: {active_balance_in_kopecks: 1200}})
        // 3.5.2 Добавить атрибут записи
        await collection.updateOne({'user.first_name': 'Yaroslav'}, {$set: {is_esim: true}})
        // 3.5.3 Удалить атрибут у записи
        await collection.updateOne({'user.first_name': 'Yaroslav'}, {$unset: {is_esim: false}})

    } catch (err) {
        console.log(err)
    } finally {
        await mongoClient.close()
    }
}

run()