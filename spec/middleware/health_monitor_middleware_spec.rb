RSpec.describe HealthMonitorMiddleware do
  let(:rack_app) { ->(_env) { [200, {}, ['Hello from Rack']] } }

  let(:middleware) do
    described_class.new(rack_app, 'the_name')
  end

  describe '#call' do
    shared_examples_for 'calls the rack app' do
      it 'calls the underlying rack app' do
        expect(rack_app).to receive(:call).with(env)
        subject
      end

      it "returns the underlying rack app's response" do
        expect(subject.last.first).to eq('Hello from Rack')
      end
    end

    shared_examples_for 'returns a health monitor response' do
      it 'does not call the underlying rack app' do
        expect(rack_app).not_to receive(:call).with(env)
        subject
      end

      context 'health status is down' do
        let(:monitor_status) { :down }

        it 'returns 503' do
          expect(subject.first).to eq(503)
        end
      end

      context 'health status is up' do
        let(:monitor_status) { :up }

        it 'returns 200' do
          expect(subject.first).to eq(200)
        end
      end
    end

    shared_examples_for 'response content type' do |expected_content_type|
      it "response content type is set to #{expected_content_type}" do
        expect(subject[1]['Content-Type']).to eq(expected_content_type)
      end
    end

    let(:env) do
      {
        'REQUEST_URI' => request_uri,
        'rack.input' => StringIO.new
      }
    end

    let(:monitor_status) { :up }
    let(:monitor_data) do
      {
        status: monitor_status
      }
    end

    subject { middleware.call(env) }

    before do
      allow(middleware.class.class_variable_get(:@@monitor))
        .to receive(:get_status).and_return(monitor_data)
    end

    context 'request_uri is /' do
      let(:request_uri) { '/' }
      include_examples 'calls the rack app'
    end

    context 'request_uri is /v1/users/evil-bot' do
      let(:request_uri) { '/v1/users/evil-bot' }
      include_examples 'calls the rack app'
    end

    context 'request_uri is /health_monitor' do
      let(:request_uri) { '/health_monitor' }
      include_examples 'returns a health monitor response'
      include_examples 'response content type', 'application/json'
    end

    context 'request_uri is /health_monitor_pingdom' do
      let(:request_uri) { '/health_monitor_pingdom' }
      include_examples 'returns a health monitor response'
      include_examples 'response content type', 'application/xml'
    end
  end
end
